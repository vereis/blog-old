const colors = require('tailwindcss/colors')
const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    colors: {
      rose: colors.rose,
      coolGray: colors.blueGray,
      ...defaultTheme.colors
    },
    extend: {
      zIndex: {
        '-10': '-10',
      },
      fontFamily: {
        'sans': ['Inter', ...defaultTheme.fontFamily.sans],
        'mono': ['Fira Code', ...defaultTheme.fontFamily.mono]
      }
    },
  },
  variants: {
    extend: {}
  },
  plugins: [],
}
