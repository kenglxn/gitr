q =
  dequeue: (fns, cb) ->
    fn = fns.pop()
    return cb() unless fn
    fn ->q.dequeue fns, cb

exports = module.exports = q