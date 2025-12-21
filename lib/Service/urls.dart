class Urls {
  static const BaseUrl = "https://dzda.in/CareLab/public/api/";
  // static const BaseUrl = "https://dzda.in/CareTest/public/api/";

  // This is a post api and the parameters are 'username' & 'password'
  static const LoginUrl = "${BaseUrl}login";

  // This is a get api without any parameter
  static const UsernameUrl = "${BaseUrl}getusername";

  /* This is a post api and the parameters are
    "time":"time",
    "date":"date",
    "case_no":"case_no",
    "slip_no":"slip_no",
    "received_by":"received_by",
    "patient_name":"patient_name",
    "year":"year",
    "month":"month",
    "gender":"gender",
    "mobile":"mobile    ",
    "child_male":"1",
    "child_female":"2",
    "address":"address",
    "agent":"agent",
    "doctor":"doctor",
    "test_name":"test_name",
    "test_rate":"test_rate",
    "total_amount":"100",
    "discount":"200",
    "after_discount":"300",
    "advance":"400",
    "balance":"500",
    "pay_mode":"pay_mode",
    "discount_type":"discount_type"
  * */

  static const CaseEntryUrl = "${BaseUrl}caseentry";

  static const CaseEntryListUrl = "${BaseUrl}caselist";
  static const CaseNumberUrl = "${BaseUrl}getcaseno";
  static const PaymentHistoryUrl = "${BaseUrl}getpaymenthistory";

  static const GetRateListUrl = "${BaseUrl}getratelist";
  static const GetStaffListUrl = "${BaseUrl}getstaff";
  static const GetAgentListUrl = "${BaseUrl}getagent";
  static const GetDoctorListUrl = "${BaseUrl}getdoctor";

  // {
  // "name" : "Sourabh Kumar",
  // "date" : "16-08-2025",
  // "slipno" : "66786",
  // "age" : "67",
  // "sex" : "Male",
  // "referredby" : "Dr Ujjal Dutta",
  // "filename" : "p_66786",
  // "main_file" : "NORMALFORMAT.docx"
  // }

  static const CreateReportUrl = "https://dzda.in/DocApi/public/api/generate-word";

  static const CheckReportUrl = "https://dzda.in/DocApi/public/api/find-file?filename=";

  // /api/getrevenue?today=8-11-2025
  // /api/getrevenue?month=11&year=2025
  // /api/getrevenue?year=2025
  // /api/getrevenue?today=8-11-2025&month=11&year=2025

  static const GetRevenue = "${BaseUrl}getrevenue?";

  // /api/monthly-chart
  // /api/monthly-chart?year=2025

  static const MonthlyChart = "${BaseUrl}monthlyChart";


  static const StaffCollection = "${BaseUrl}staff-today-collection?today=";



  static const DoctorCollection = "${BaseUrl}doctor-collection?";

  static const AgentCollection = "${BaseUrl}agent-collection?";


  static const BetweenDateCollection = "${BaseUrl}collectionBetweenDates?";

  static const UpdateTest = "${BaseUrl}update-test";

  ///Raju/500/dr/25-11-2025/Sourabh/For Oil/Cash
  static const SaveExpanses = "${BaseUrl}save-expanses";

  static const GetExpanses = "${BaseUrl}get-expanses";

  static const SaveStaff = "${BaseUrl}save-staff";

  static const DeleteStaff = "${BaseUrl}delete-staff";
  static const DeleteRateList = "${BaseUrl}delete-test/";

  static const GetSingleCase = "${BaseUrl}get-single-case/";


  static const UpdateCase = "${BaseUrl}update-case/";

  //documents[]
  static const UploadReport = "https://dzda.in/DocApi/public/api/documents/upload";



}