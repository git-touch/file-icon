import gulp from "gulp";
import through2 from "through2";

function gallery() {
  return gulp
    .src("../seti/lib/**/*")
    .pipe(
      through2.obj((file, _, cb) => {
        if (file.isBuffer()) {
          file.contents = Buffer.from(
            file.contents
              .toString()
              .replace("package:flutter", "package:flutter_web")
              .replace("fontPackage: 'seti'", ""),
            "utf8"
          );
        }
        cb(null, file);
      })
    )
    .pipe(gulp.dest("../seti-gallery/lib/generated"));
}

export function watch() {
  return gulp.watch("../seti/lib/**/*", { ignoreInitial: false }, gallery);
}

export default cb => {
  gallery();
  cb();
};
