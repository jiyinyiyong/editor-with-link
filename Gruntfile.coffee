
module.exports = (grunt) ->

  grunt.initConfig
    coffee:
      options:
        bare: yes
        sourceMap: no
      main:
        cwd: 'coffee/'
        expand: yes
        src: '*.coffee'
        dest: 'build/'
        ext: '.js'
    stylus:
      main:
        cwd: 'styl/'
        expand: yes
        src: '*.styl'
        dest: 'build/'
        ext: '.css'
    jade:
      options:
        pretty: yes
      main:
        cwd: 'jade/'
        expand: yes
        src: '*.jade'
        dest: 'build/'
        ext: '.html'
    watch:
      options:
        nospawn: yes
        livereload: yes
        debounceDelay: 100
      coffee:
        files: 'coffee/*'
        tasks: ['coffee']
      styl:
        files: 'styl/*'
        tasks: ['stylus']
      jade:
        files: 'jade/*'
        tasks: ['jade']

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-stylus')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-watch')

  grunt.registerTask 'dev', ['coffee', 'jade', 'stylus', 'watch']