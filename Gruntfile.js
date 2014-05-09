// Generated on 2014-04-26 using generator-chromeapp 0.2.8
'use strict';

// # Globbing
// for performance reasons we're only matching one level down:
// 'test/spec/{,*/}*.js'
// use this if you want to recursively match all subfolders:
// 'test/spec/**/*.js'

module.exports = function (grunt) {

    // Load grunt tasks automatically
    require('load-grunt-tasks')(grunt);

    // Time how long tasks take. Can help when optimizing build times
    require('time-grunt')(grunt);

    // Configurable paths
    var config = {
        app: 'app',
        dist: 'dist',
        manifest: grunt.file.readJSON('app/manifest.json'),
        tasks: grunt.cli.tasks
    };

    // Define the configuration for all the tasks
    grunt.initConfig({

        // Project settings
        config: config,

        // Watches files for changes and runs tasks based on the changed files
        watch: {
            bower: {
                files: ['bower.json'],
                tasks: ['bowerInstall']
            },
            coffee: {
                files: ['<%= config.app %>/{elements,scripts}/**/*.{coffee,litcoffee,coffee.md}'],
                tasks: ['coffee:dist'],
                options: {
                    livereload: true
                }
            },
            gruntfile: {
                files: ['Gruntfile.js']
            },
            styles: {
                files: ['<%= config.app %>/{elements,styles}/**/*.css'],
                tasks: [],
                options: {
                    livereload: true
                }
            },
            livereload: {
                options: {
                    livereload: '<%= connect.options.livereload %>'
                },
                files: [
                    '.tmp/elements/{,*/}*.css',
                    '.tmp/styles/{,*/}*.css',
                    '.tmp/elements/{,*/}*.js',
                    '.tmp/scripts/{,*/}*.js',
                    '<%= config.app %>/{elements,scripts,styles}/**/*',
                    '<%= config.app %>/{,*/}*.html',
                    '<%= config.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}',
                    '<%= config.app %>/manifest.json',
                    '<%= config.app %>/_locales/{,*/}*.json'
                ]
            }
        },

        // Grunt server and debug server settings
        connect: {
            options: {
                port: 9000,
                livereload: 35729,
                // change this to '0.0.0.0' to access the server from outside
                hostname: 'localhost',
                open: true
            },
            server: {
                options: {
                    middleware: function(connect) {
                        return [
                            connect.static('.tmp'),
                            connect().use('/bower_components', connect.static('./bower_components')),
                            connect.static(config.app)
                        ];
                    }
                }
            },
            chrome: {
                options: {
                    open: false,
                    base: [
                        '<%= config.app %>'
                    ]
                }
            },
            test: {
                options: {
                    base: [
                        'test',
                        '<%= config.app %>'
                    ]
                }
            }
        },

        // Empties folders to start fresh
        clean: {
            server: '.tmp',
            chrome: '.tmp',
            dist: {
                files: [{
                    dot: true,
                    src: [
                        '.tmp',
                        '<%= config.dist %>/*',
                        '!<%= config.dist %>/.git*'
                    ]
                }]
            }
        },

        // Make sure code styles are up to par and there are no obvious mistakes
//        jshint: {
//            options: {
//                jshintrc: '.jshintrc',
//                reporter: require('jshint-stylish')
//            },
//            all: [
//                'Gruntfile.js',
//                '<%= config.app %>/{elements,scripts}/{,*/}*.js',
//                '!<%= config.app %>/{elements,scripts}/vendor/*',
//                'test/spec/{,*/}*.js'
//            ]
//        },
        jasmine: {
            all: {
                options: {
                    specs: 'test/spec/{,*/}*.js'
                }
            }
        },

        // Compiles CoffeeScript to JavaScript
        coffee: {
            server: {
                files: [{
                    expand: true,
                    cwd: '<%= config.app %>',
                    src: '{elements,scripts}/**/*.{coffee,litcoffee,coffee.md}',
                    dest: '.tmp/',
                    ext: '.js'
                }]
            },
            dist: {
                files: [{
                    expand: true,
                    cwd: '<%= config.app %>',
                    src: '{elements,scripts}/**/*.{coffee,litcoffee,coffee.md}',
                    dest: '<%= config.app %>/',
                    ext: '.js'
                }]
            }
        },

        // Compiles Sass to CSS and generates necessary files if requested
        compass: {
            options: {
                sassDir: '<%= config.app %>',
                cssDir: '<%= config.app %>',
                generatedImagesDir: '<%= config.dist %>/images/generated',
                imagesDir: '<%= config.app %>/images',
                javascriptsDir: '<%= config.app %>/elements',
                fontsDir: '<%= config.app %>/elements',
                importPath: '<%= config.app %>/bower_components',
                httpGeneratedImagesPath: '/images/generated',
                relativeAssets: false,
                assetCacheBuster: false
            },
            server: {
                options: {
                    cssDir: '.tmp',
                    generatedImagesDir: '.tmp/images/generated',
                    debugInfo: true
                }
            },
            chrome: {
                options: {
                    generatedImagesDir: '<%= config.app %>/images/generated',
                    debugInfo: true
                }
            },
            dist: {
            }
        },

        // Copies remaining files to places other tasks can use
        copy: {
            dist: {
                files: [{
                    expand: true,
                    dot: true,
                    cwd: '<%= config.app %>',
                    dest: '<%= config.dist %>',
                    src: [
                        // All html, js, css and assets from elements
                        'elements/**/*.{css,js,html}', 'elements/**/assets/*',
                        // Stupid bootstrap assets
                        'elements/app/bootstrap/**/*',
                        // All bower components' assets (but not source)
                        'bower_components/**/*.{css,js,html}',

                        '*.{ico,png,txt}',
                        // All images
                        'images/**/*',
                        '{,*/}*.html',
                        '{,*/}*.js',
                        'styles/**/*',
                        'scripts/tock/*.js',
                        '_locales/{,*/}*.json'
                    ]
                }]
            },
            styles: {
                expand: true,
                dot: true,
                cwd: '<%= config.app %>',
                dest: '.tmp/',
                src: '{,*/}*.css'
            }
        },

        // Run some tasks in parallel to speed up build process
        concurrent: {
            server: [
                'coffee:dist',
                'compass:server',
                'copy:styles'
            ],
            chrome: [
                'coffee:dist',
                'compass:chrome',
                'copy:styles',
//                'vulcanize:dist'
            ],
            dist: [
                'coffee:dist',
                'compass:dist',
                'copy:styles',
//                'vulcanize:dist'
            ],
            test: [
                'coffee',
                'copy:styles'
            ]
        },

        // Merge event page, update build number, exclude the debug script
        chromeManifest: {
            dist: {
                options: {
                    buildnumber: true,
                    background: {
                        target: 'scripts/background.js',
                        exclude: [
                            'scripts/chromereload.js'
                        ],
                        persistent: true
                    }
                },
                src: '<%= config.app %>',
                dest: '<%= config.dist %>'
            }
        },

        // Compress files in dist to make Chrome Apps package
        compress: {
            dist: {
                options: {
                    archive: 'package/tock-<%= config.manifest.version %>.zip'
                },
                files: [{
                    expand: true,
                    cwd: 'dist/',
                    src: ['**'],
                    dest: ''
                }]
            }
        },

        vulcanize: {
          dist: {
            options: {
              csp:      true
            },
            files:   {
              'dist/vulcanized_index.html': ['dist/index.html', 'dist/**/*.html']
            }
          }
        }
    });

    grunt.registerTask('debug', function (platform) {
        var watch = grunt.config('watch');
        platform = platform || 'chrome';
        
        // Configure compass task for debug[server:chrome] task
        watch.compass = {
            files: ['<%= config.app %>/{styles,elements}/{,*/}*.{scss,sass}'],
            tasks: ['compass:' + platform]
        };

        // Configure style task for debug:server task
        if (platform === 'server') {
            watch.styles.tasks = ['newer:copy:styles'];
            watch.styles.options.livereload = false;
            watch.coffee.tasks = ['coffee:server'];
            watch.styles.options.livereload = false;
        }

        // Configure updated watch task
        grunt.config('watch', watch);

        grunt.task.run([
            'clean:' + platform,
            'concurrent:' + platform,
            'connect:' + platform,
            'watch'
        ]);
    });

    grunt.registerTask('test', [
        'connect:test',
        'jasmine'
    ]);

    grunt.registerTask('build', [
        'clean:dist',
        'chromeManifest:dist',
        'concurrent:dist',
        'concat',
        'copy',
//        'vulcanize:dist',
        'compress'
    ]);

    grunt.registerTask('default', [
        'newer:jshint',
        'test',
        'build'
    ]);
};
