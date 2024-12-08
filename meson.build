project('ezdwm', 'cpp', version: '0.1.0', default_options: ['cpp_std=c++20'])

name = 'ezdwm'

add_global_arguments('-DVERSION="0.1.0"', '-DXINERAMA', '-D_DEFAULT_SOURCE', language: 'cpp')

sources = [
  'src/main.cpp',
  'src/drw.cpp',
  'src/util.cpp',
]

includes = include_directories(
  'include',
  '/usr/include/freetype2',
  run_command('pkg-config', 'x11', '--cflags').stdout().strip(),
)

dependencies = [
  dependency('x11'),
  dependency('xft', method: 'pkg-config'),
  dependency('xinerama'),
  dependency('fontconfig'),
]

executable(name, sources, include_directories: includes, dependencies: dependencies)