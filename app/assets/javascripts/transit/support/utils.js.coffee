@Transit.utils = 
  findClass:(base, name)->
    console.log(base, name)
    name = name.replace(/\[(\w+)\]/g, '.$1')
      .replace(/^\./, '')
    parts = name.split('.')
    while parts.length
      part = parts.shift()
      if part of base
        base = base[part]
      else return
    base