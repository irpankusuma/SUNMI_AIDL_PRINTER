///
///       CONFIGURATION FILES
///

const String api_dev = 'https://api.alam-sutera.com/ASRIDesk/api/';
const String api_prod = 'https://api.alam-sutera.com/ASRIDesk/api/';
const String prefix = "asribilling_";

const bool isProduction = false;
const String api = isProduction == true ? api_prod :api_dev;
