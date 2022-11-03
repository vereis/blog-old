const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: ["./js/**/*.js", "../lib/*_web.ex", "../lib/*_web/**/*.*ex"],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter", ...defaultTheme.fontFamily.sans],
        serif: ["Libre Baskerville", ...defaultTheme.fontFamily.serif],
        mono: ["Fira Code", ...defaultTheme.fontFamily.mono],
      },
      spacing: {
        128: "32rem",
      },
      typography: {
        DEFAULT: {
          css: {
            del: {
              color: "#fb7185",
            },
          },
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/typography"),
    require("@tailwindcss/line-clamp"),
  ],
};
