// Import necessary libraries ================================================
var createError = require("http-errors");
var express = require("express");
const mongoose = require("mongoose");
var path = require("path");
var cookieParser = require("cookie-parser");
var logger = require("morgan");
const cors = require("cors");

const app = express();

// Import routes =============================================================
const indexRouter = require("./routes/index");
const authRouter = require("./routes/auth-routing");
const usersRouter = require("./routes/users-routing");
const bitbucketRouter = require("./routes/bitbucket-routing");
const pipelinesRouter = require("./routes/pipelines-routing");
const { fetchDataAndStorePipelines } = require("./services/db");

// Middleware setup =========================================================
app.use(logger("dev"));
app.use(cookieParser());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, "public")));
app.use(cors());
// Potentially more secure later
// app.use(cors({
//   origin: 'http://your-trusted-origin.com'
// }));

// view engine setup
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "jade");

const { auth } = require("express-oauth2-jwt-bearer");

const portAuth = process.env.PORT || 8080;

const jwtConfig = {
  audience: process.env.API_AUDIENCE,
  issuerBaseURL: process.env.ISSUE_URL,
  tokenSigningAlg: process.env.TOKEN_SIGN_IN,
};
console.log(jwtConfig);
const jwtCheck = auth(jwtConfig);

// // enforce on all endpoints
app.use(jwtCheck);

app.get("/authorized", function (req, res) {
  res.send("Secured Resource");
});

app.listen(portAuth);

console.log("Running on port ", portAuth);

// MongoDB connection =====================================================
// MongoDB connection string
const uri = process.env.MONGODB_CONNECTION_STRING;

console.log("uri: ", uri);
mongoose.connect(uri, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  serverSelectionTimeoutMS: 5000,
  connectTimeoutMS: 5000,
});

// Use imported routes ====================================================
app.use("/", indexRouter);
app.use("/auth", authRouter);
app.use("/users", usersRouter);
app.use("/bitbucket", bitbucketRouter);
app.use("/pipelines", pipelinesRouter);

// Catch 404 and forward to error handler ==================================
app.use(function (req, res, next) {
  next(createError(404));
});

// Error handling middleware
app.use(function (err, req, res, next) {
  res.status(err.status || 500).send({ message: err.message });
});

// Error handler ===========================================================
app.use(function (err, req, res, next) {
  // Set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render("error");
});

// Start the server =======================================================
const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

// Run fetchBitbucketPipelines every 15 seconds
setInterval(fetchDataAndStorePipelines, 22000);

module.exports = app;
