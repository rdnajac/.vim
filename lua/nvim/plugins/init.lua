return vim.iter(nv.submodules()):map(require):map(nv.fn.ensure_list):flatten():totable()
