const multer = require('multer');
const path = require('path');

// Set up storage for uploaded files
const storage = multer.diskStorage({
  destination: function(req, file, cb) {
    cb(null, 'upload/');
  },
  filename: function(req, file, cb){
    cb(null, file.originalname);
  }
});

// Create the multer instance
const upload = multer({ 
    storage: storage,
    fileFilter: function (req, file, cb) {
        const filetypes = /csv/;
        const mimetype = filetypes.test(file.mimetype);
        const extname = filetypes.test(path.extname(file.originalname).toLowerCase());

        if (mimetype && extname) {
            return cb(null, true);
        }

        cb("Error: File upload only supports the following filetypes - " + filetypes);
    }
 }).single('file');

module.exports = upload;