alias Exmen.Discover.{Discoverer, Middleware}
alias Exmen.Discover.Middleware.{Math, Conditional}

middlewares = [
  %Middleware{module: Math},
  %Middleware{module: Conditional}
]

{:ok, discoverer} = Discoverer.start_link(middlewares)
