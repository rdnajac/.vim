if not Snacks then
  print('Snacks is not available')
  return
end
Snacks.util.set_hl({
  Desc = 'Chromatophore',
  -- File = 'Special',
  -- Dir = 'NonText',
  -- Footer = 'Title',
  -- Header = 'Title',
  Icon = 'Chromatophore',
  Key = 'Chromatophore',
  Normal = 'Chromatophore',
  Terminal = 'Chromatophore',
  Special = 'Chromatophore',
  -- Title = 'Title',
}, { prefix = 'SnacksDashboard', default = true })

Snacks.util.set_hl({
  IndentScope = 'Chromatophore',
  -- Title = 'Title',
}, { prefix = 'Snacks', default = true })
