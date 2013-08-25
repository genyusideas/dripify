module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-contrib-jade');
  grunt.loadNpmTasks('grunt-regarde');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-clean');

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    watchFiles: {
      jade: {
        files: ['app/views/client/**/*.jade'],
        tasks: ['jade:compile']
      }
    },
    jade: {
      compile: {
        options: {
          data: {
            debug: false
          }
        },
        files: grunt.file.expandMapping(['app/views/client/**/*.jade'], 'app/assets/javascripts/', {
          rename: function(base, path) {
            return base + path.replace(/\.jade$/, '.html');
          }
        })
      }
    },
    clean: {
      dist: ['app/assets/javascripts/views']
    }
  });

  grunt.renameTask('regarde', 'watchFiles');
  grunt.registerTask('build', [
    'clean',
    'jade:compile'
  ]);

  grunt.registerTask('watch', [
    'build',
    'watchFiles'
  ]);

  grunt.registerTask('default', ['build']);
};
