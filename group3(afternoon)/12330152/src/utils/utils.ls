require! [path, fs]

exports.birthtime = (homework, student, cb)!->
  filepath = path.join __dirname, '..', '..', 'submits', homework, student
  fs.stat filepath, (err, stats)!->
    if err
      cb err
    else
      cb null, stats.birthtime
