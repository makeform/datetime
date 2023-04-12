module.exports =
  pkg:
    name: "@makeform/date", extend: name: '@makeform/common'
    dependencies: [
      {name: "dayjs", path: "dayjs.min.js"}
      {name: "lddatetimepicker"}
      {name: "lddatetimepicker", path: "index.min.css", type: \css, global: true}
    ]
  init: (opt) -> opt.pubsub.fire \subinit, mod: mod(opt)
mod = ({root, ctx, data, parent, t, i18n}) ->
  {ldview,lddatetimepicker} = ctx
  lc = {}
  config:
    time: enabled: type: \boolean
  init: ->
    @on \change, ~> @view.render <[input content]>
    handler = ({node}) ~> @value node.value
    @view = view = new ldview do
      root: root
      action:
        input: input: handler
        change: input: handler
      init: input: ({node}) ~>
        picker = new lddatetimepicker {
          host: node
          time: @mod.info.config.{}time.enabled
        }
        picker.on \change, -> handler({node})
      handler:
        content: ({node}) ~> if @is-empty! => 'n/a' else node.innerText = @content!
        input: ({node}) ~>
          node.value = (@value! or '')
          readonly = !!@mod.info.meta.readonly
          if readonly => node.setAttribute \readonly, true
          else node.removeAttribute \readonly
          node.classList.toggle \is-invalid, @status! == 2
          if @mod.info.config.placeholder => node.setAttribute \placeholder, @mod.info.config.placeholder
          else node.removeAttribute \placeholder

  render: -> @view.render!

