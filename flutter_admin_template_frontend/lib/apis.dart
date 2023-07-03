const httpCodeOK = 20000;
const String baseUrl = "http://127.0.0.1:15234";

const Map<String, String> apiDetails = {
  "login": "$baseUrl/system/user/login",
  "signinlog": "$baseUrl/system/log/signin/all", // GET
  "logSummary": "$baseUrl/system/log/summary",

  // router
  "currentRouters": "$baseUrl/system/router/current", // Get
  "allRouters": "$baseUrl/system/router/all", // Get

  // role
  "getAllRoles": "$baseUrl/system/role/all", //get
  "getDetailsById": "$baseUrl/system/role/details", // get

  // api
  "getApiByRouter": "$baseUrl/system/api/byRouter", //get
};
