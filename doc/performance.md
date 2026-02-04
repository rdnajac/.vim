# Lua Performance

original source: <https://springrts.com/wiki/Lua_Performance>

## LuaJIT

LuaJIT traces hot loops and optimizes them aggressively.

Examples that are **mostly irrelevant** under LuaJIT:

- Localizing globals (math.min, math.max, etc.)
- `x*x` vs `x^2`
- `if x > y then` vs `math.max`
- `a.foo` vs `a["foo"]`
- `or` vs nil-check
- buffering `local y = a[n]` in simple loops
- `pairs` vs `ipairs` vs numeric for (inside hot loops)

In JIT-compiled traces, these usually compile down to the same machine code or very close to it.

Localization still helps **interpreter mode**,
but in JIT mode the global lookup cost is hoisted or eliminated.

---

## Advice that is still relevant under LuaJIT

These affect allocations, trace aborts, or prevent JIT compilation:

### Function allocations in loops (TEST 8)

```lua
func1(1,2,function(a) return a*2 end)
```

Allocates a closure every iteration. LuaJIT cannot remove this.
Always hoist functions out of loops.

### Table allocation patterns (TEST 12, 13)

- Pre-sized literal tables are faster
- Reusing tables is faster
- Avoid creating short-lived tables in hot loops
- Static table reuse beats per-iteration construction

This directly reduces GC pressure, which matters
even more under LuaJIT because GC pauses can deopt traces.

### Avoid `table.insert` in hot loops

`a[i] = v` or manual index tracking is faster and easier for the JIT to optimize.

### Avoid `unpack` in hot loops

`unpack` (or `table.unpack`) is a C call that often prevents good trace formation.

### however

- Localizing class methods inside the loop is not necessary (LuaJIT hoists method lookups)
- `ipairs` over dense arrays is usually optimized
- numeric `for` is still the best, but the gap is much smaller
- `pairs` is still bad for hot loops due to iterator semantics
- `%` is a bytecode op and JITs well. `math.fmod` is a C call and often breaks traces.

Avoid patterns that cause trace aborts:

- changing types in loops
- growing tables in unpredictable ways
- polymorphic function calls
- metamethods in hot paths

## FFI

- structs
- arrays
- math
