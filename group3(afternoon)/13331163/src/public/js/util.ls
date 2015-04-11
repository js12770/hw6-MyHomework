module.exports = {
  unique: (array)->
    res = []
    json = {}
    for val in array
      if !(json[val.coursename])
        res.push val
        json[val.coursename] = 1
    return res
}
