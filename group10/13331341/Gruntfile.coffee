module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)
  path = require('path')
  DEBUG = false

  grunt.initConfig 
    pkg: grunt.file.readJSON("package.json")

    clean: 
      all:
        dot: true
        files:
          src: ["dest/*"]

    copy:
      copy_all_other_files:
        files: [
          expand: true
          cwd: "src/"
          src: ["**/*.*", "!**/*.ls"]
          dest: "dest/"
        ]

    livescript:
      options:
        bare: false
      index:
        options:
          bare: false
        expand: true
        cwd: "src/"
        src: ["index.ls"]
        dest: "dest/"
        ext: ".js"
      server:
        expand: true
        cwd: "server/"
        src: ["**/*.ls"]
        dest: "dest/"
        ext: ".js"

    express:
      dev:
        options:
          server: path.resolve('dest/server.js')
          bases: [path.resolve('dest')]
          livereload: 8001
          # serverreload: true
          port: 8000

    delta:
      options:
        livereload: true

      livescriptserver:
        files: ["server/**/*.ls"]
        tasks: ["newer:livescript:server", "express-restart"]
        options:
          livereload: false

      assests:
        files: ["src/assests/**/*"]
        tasks: [
          "newer:copy:copy_all_other_files"
        ]

      express:
        files: ["dest/**/*.*", "!dest/server.js"]
        tasks: []
        options:
          livereload: 8001

      grunt:
        files: ['Gruntfile.coffee']

 
  grunt.renameTask "watch", "delta"

  grunt.registerTask "default", [
    "clean"
    "copy"
    "livescript"
  ]
  grunt.registerTask "watch", [
    "clean"
    "copy"
    "livescript"
    "express"
    "delta"
  ]

  
  