const httpCodeOK = 20000;
const String baseUrl = "http://127.0.0.1:15234";

const Map<String, String> apiDetails = {
  "login": "$baseUrl/system/user/login",
  "signinlog": "$baseUrl/system/log/signin/all", // GET
  "logSummary": "$baseUrl/system/log/summary",

  // router
  "currentRouters": "$baseUrl/system/router/current", // Get
};
