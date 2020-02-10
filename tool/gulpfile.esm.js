// References:
// https://github.com/microsoft/vscode/blob/master/extensions/theme-seti/build/update-icon-theme.js
// https://github.com/microsoft/vscode/blob/master/extensions/theme-seti/icons/vs-seti-icon-theme.json

import fs from "fs";
import gulp from "gulp";
import through2 from "through2";
import { execSync } from "child_process";

/**
 * @param {string} key
 */
function getCodePointVarName(key) {
  return `_${key.toLowerCase().replace("-", "_")}`;
}

/**
 * @param {string} key
 */
function getColorVarName(key) {
  return `_${key.toLowerCase().replace("-", "_")}`;
}

/**
 * #123, #112233 -> 0xff112233
 * @param {string} cssHex
 */
function convertColor(cssHex) {
  if (cssHex.startsWith("#")) {
    cssHex = cssHex.substring(1);
  }
  if (cssHex.length == 3) {
    cssHex = cssHex
      .split("")
      .map(char => char + char)
      .join("");
  }
  return "0xff" + cssHex;
}

function copyFont() {
  return gulp
    .src("../vendor/seti-ui/styles/_fonts/seti/seti.ttf")
    .pipe(gulp.dest("../seti/fonts"));
}

function generateCode() {
  const mappingLess = fs.readFileSync(
    "../vendor/seti-ui/styles/components/icons/mapping.less",
    "utf8"
  );

  // Seems Less.js did not expose its parser, so we use regexp here.
  // Taken from https://github.com/microsoft/vscode/blob/ae42e42cf10df59773851b2d69db08189d6989eb/extensions/theme-seti/build/update-icon-theme.js#L302
  const reg = /\.icon-(?:set|partial)\(['"]([\w-\.]+)['"],\s*['"]([\w-]+)['"],\s*(@[\w-]+)\)/g;

  const iconSetMap = {};
  const partialMap = {};

  let result;
  while ((result = reg.exec(mappingLess))) {
    const arr = result[0].split(",");
    const type = arr[1].trim().slice(1, -1);
    const color = arr[2].trim().slice(1, -1);

    if (arr[0].startsWith(".icon-set")) {
      const key = arr[0].trim().slice(11, -1);
      if (iconSetMap[key.toLowerCase()]) {
        console.warn(`Duplicated key: ${key}`);
      }
      iconSetMap[key.toLowerCase()] = { type, color };
    } else if (arr[0].startsWith(".icon-partial")) {
      const key = arr[0].trim().slice(15, -1);
      if (iconSetMap[key.toLowerCase()]) {
        console.warn(`Duplicated key: ${key}`);
      }
      iconSetMap[key.toLowerCase()] = { type, color };
    } else {
      throw new Error("should not be here");
    }
  }
  // console.log(iconSetMap);
  // console.log(partialMap);

  // Code points
  const codePoints = fs
    .readFileSync("../vendor/seti-ui/styles/_fonts/seti.less", "utf8")
    .split("\n")
    .filter(line => /^\s+@/.test(line))
    .map(line => {
      let arr = line
        .trim()
        .slice(0, -1)
        .split(":")
        .map(x => x.trim());

      const type = arr[0].slice(1);
      const codePoint = arr[1].slice(1, -1).replace("\\", "0x");

      if (type === "pseudo-selector") return;
      return { type, codePoint };
    })
    .filter(x => x);
  // console.log(codePoints);

  // Colors
  const colorPresets = [
    // https://github.com/jesseweed/seti-ui/blob/904c16acced1134a81b31d71d60293288c31334b/README.md#adding-file-icons
    `blue`,
    `grey`,
    `green`,
    `orange`,
    `pink`,
    `purple`,
    `red`,
    `white`,
    `yellow`,

    "grey-light",
    "ignore"
  ];
  const colors = fs
    .readFileSync("../vendor/seti-ui/styles/ui-variables.less", "utf8")
    .split("\n")
    .filter(x => {
      return colorPresets.some(color => x.startsWith("@" + color + ":"));
    })
    .map(line => {
      const arr = line
        .trim()
        .slice(1, -1)
        .split(":")
        .map(x => x.trim());

      return {
        name: arr[0],
        value: convertColor(arr[1])
      };
    });
  // console.log(colors);

  // Generate code: data.dart
  let code = "// GENERATED CODE - DO NOT MODIFY BY HAND\nimport 'meta.dart';";
  codePoints.forEach(({ type, codePoint }) => {
    code += `const ${getCodePointVarName(type)} = ${codePoint};\n`;
  });
  colors.forEach(({ name, value }) => {
    code += `const ${getColorVarName(name)} = ${value};\n`;
  });
  code += `const _seti_primary = _blue;`;

  code += `const iconSetMap = {`;
  Object.entries(iconSetMap).forEach(([k, v]) => {
    code += `'${k}': SetiMeta(${getCodePointVarName(v.type)}, ${getColorVarName(
      v.color
    )}),`;
  });
  code += "};";

  // code += `const partialMap = {`;
  // Object.entries(partialMap).forEach(([k, v]) => {
  //   code += `'${k}': [${getCodePointVarName(v.type)}, ${getColorVarName(
  //     v.color
  //   )}],`;
  // });
  // code += "};";

  fs.writeFileSync("../file_icon/lib/data.dart", code);
}

export default cb => {
  copyFont();
  generateCode();
  cb();
};
