const httpCodeOK = 20000;
const String baseUrl = "http://127.0.0.1:15234";

const Map<String, String> apiDetails = {
  "login": "/system/user/login",
  "signinlog": "/system/log/signin/all", // GET
  "logSummary": "/system/log/summary",

  // router
  "currentRouters": "/system/router/current", // Get
  "allRouters": "/system/router/all", // Get

  // role
  "getAllRoles": "/system/role/all", //get
  "getDetailsById": "/system/role/details", // get

  // api
  "getApiByRouter": "/system/api/byRouter", //get
  "getApiByRole": "/system/api/byRole", //get
  "getApiCurrent": "/system/api/current", //get
};

const List<String> reservedApis = [
  "/system/user/login",
  "/system/api/current",
  "/system/router/current",
  "/system/role/details/current",
  "/system/user/info"
];
