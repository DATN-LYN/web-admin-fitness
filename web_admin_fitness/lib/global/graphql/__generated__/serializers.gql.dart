// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart' show StandardJsonPlugin;
import 'package:ferry_exec/ferry_exec.dart';
import 'package:gql_code_builder/src/serializers/operation_serializer.dart'
    show OperationSerializer;
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart'
    show
        GChangePasswordInputDto,
        GFILTER_OPERATOR,
        GFilterDto,
        GLoginInputDto,
        GQueryFilterDto,
        GRegisterInputDto,
        GUpsertCategoryInputDto,
        GUpsertExerciseInputDto,
        GUpsertInboxInputDto,
        GUpsertProgramInputDto,
        GUpsertSupportInputDto,
        GUpsertUserExerciseInputDto,
        GUpsertUserInputDto,
        GUpsertUserProgramInputDto,
        GUpsertUserStatisticsInputDto;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/mutation_logout.data.gql.dart'
    show GLogoutData, GLogoutData_logout;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/mutation_logout.req.gql.dart'
    show GLogoutReq;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/mutation_logout.var.gql.dart'
    show GLogoutVars;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/mutation_register.data.gql.dart'
    show GRegisterData, GRegisterData_register;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/mutation_register.req.gql.dart'
    show GRegisterReq;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/mutation_register.var.gql.dart'
    show GRegisterVars;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_login.data.gql.dart'
    show GLoginData, GLoginData_login, GLoginData_login_user;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_login.req.gql.dart'
    show GLoginReq;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_login.var.gql.dart'
    show GLoginVars;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_refresh_token.data.gql.dart'
    show GRefreshTokenData, GRefreshTokenData_refreshToken;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_refresh_token.req.gql.dart'
    show GRefreshTokenReq;
import 'package:web_admin_fitness/global/graphql/auth/__generated__/query_refresh_token.var.gql.dart'
    show GRefreshTokenVars;
import 'package:web_admin_fitness/global/graphql/cache_handler/__generated__/mutation_change_password.data.gql.dart'
    show GChangePasswordData, GChangePasswordData_changePassword;
import 'package:web_admin_fitness/global/graphql/cache_handler/__generated__/mutation_change_password.req.gql.dart'
    show GChangePasswordReq;
import 'package:web_admin_fitness/global/graphql/cache_handler/__generated__/mutation_change_password.var.gql.dart'
    show GChangePasswordVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.data.gql.dart'
    show GCategoryData;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.req.gql.dart'
    show GCategoryReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.var.gql.dart'
    show GCategoryVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/exercise_fragment.data.gql.dart'
    show GExerciseData, GExerciseData_program, GExerciseData_program_category;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/exercise_fragment.req.gql.dart'
    show GExerciseReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/exercise_fragment.var.gql.dart'
    show GExerciseVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/i_exercise_fragment.data.gql.dart'
    show
        GIExerciseData,
        GIExerciseData_program,
        GIExerciseData_program_category;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/i_exercise_fragment.req.gql.dart'
    show GIExerciseReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/i_exercise_fragment.var.gql.dart'
    show GIExerciseVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/i_support_fragment.data.gql.dart'
    show GISupportData, GISupportData_user;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/i_support_fragment.req.gql.dart'
    show GISupportReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/i_support_fragment.var.gql.dart'
    show GISupportVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/inbox_fragment.data.gql.dart'
    show GInboxData, GInboxData_user;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/inbox_fragment.req.gql.dart'
    show GInboxReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/inbox_fragment.var.gql.dart'
    show GInboxVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/meta_fragment.data.gql.dart'
    show GMetaData;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/meta_fragment.req.gql.dart'
    show GMetaReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/meta_fragment.var.gql.dart'
    show GMetaVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.data.gql.dart'
    show GProgramData, GProgramData_category;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.req.gql.dart'
    show GProgramReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.var.gql.dart'
    show GProgramVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/support_fragment.data.gql.dart'
    show GSupportData, GSupportData_user;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/support_fragment.req.gql.dart'
    show GSupportReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/support_fragment.var.gql.dart'
    show GSupportVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_fragment.data.gql.dart'
    show GUserData;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_fragment.req.gql.dart'
    show GUserReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_fragment.var.gql.dart'
    show GUserVars;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_statistics_fragment.data.gql.dart'
    show GUserStatisticsData;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_statistics_fragment.req.gql.dart'
    show GUserStatisticsReq;
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_statistics_fragment.var.gql.dart'
    show GUserStatisticsVars;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_category.data.gql.dart'
    show GDeleteCategoryData, GDeleteCategoryData_deleteCategory;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_category.req.gql.dart'
    show GDeleteCategoryReq;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_category.var.gql.dart'
    show GDeleteCategoryVars;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_exercise.data.gql.dart'
    show GDeleteExerciseData, GDeleteExerciseData_deleteExercise;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_exercise.req.gql.dart'
    show GDeleteExerciseReq;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_exercise.var.gql.dart'
    show GDeleteExerciseVars;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_inbox.data.gql.dart'
    show GDeleteInboxData, GDeleteInboxData_deleteInbox;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_inbox.req.gql.dart'
    show GDeleteInboxReq;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_inbox.var.gql.dart'
    show GDeleteInboxVars;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_program.data.gql.dart'
    show GDeleteProgramData, GDeleteProgramData_deleteProgram;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_program.req.gql.dart'
    show GDeleteProgramReq;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_program.var.gql.dart'
    show GDeleteProgramVars;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_user.data.gql.dart'
    show GDeleteUserData, GDeleteUserData_deleteUser;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_user.req.gql.dart'
    show GDeleteUserReq;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_delete_user.var.gql.dart'
    show GDeleteUserVars;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_category.data.gql.dart'
    show GUpsertCategoryData, GUpsertCategoryData_upsertCategory;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_category.req.gql.dart'
    show GUpsertCategoryReq;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_category.var.gql.dart'
    show GUpsertCategoryVars;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_exercise.data.gql.dart'
    show GUpsertExerciseData, GUpsertExerciseData_upsertExercise;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_exercise.req.gql.dart'
    show GUpsertExerciseReq;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_exercise.var.gql.dart'
    show GUpsertExerciseVars;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_program.data.gql.dart'
    show GUpsertProgramData, GUpsertProgramData_upsertProgram;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_program.req.gql.dart'
    show GUpsertProgramReq;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_program.var.gql.dart'
    show GUpsertProgramVars;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_support.data.gql.dart'
    show
        GUpsertSupportData,
        GUpsertSupportData_upsertSupport,
        GUpsertSupportData_upsertSupport_user;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_support.req.gql.dart'
    show GUpsertSupportReq;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_support.var.gql.dart'
    show GUpsertSupportVars;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_user.data.gql.dart'
    show GUpsertUserData, GUpsertUserData_upsertUser;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_user.req.gql.dart'
    show GUpsertUserReq;
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_user.var.gql.dart'
    show GUpsertUserVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_categories.data.gql.dart'
    show
        GGetCategoriesData,
        GGetCategoriesData_getCategories,
        GGetCategoriesData_getCategories_items,
        GGetCategoriesData_getCategories_meta;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_categories.req.gql.dart'
    show GGetCategoriesReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_categories.var.gql.dart'
    show GGetCategoriesVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_category.data.gql.dart'
    show GGetCategoryData, GGetCategoryData_getCategory;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_category.req.gql.dart'
    show GGetCategoryReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_category.var.gql.dart'
    show GGetCategoryVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_current_user.data.gql.dart'
    show
        GGetCurrentUserData,
        GGetCurrentUserData_getCurrentUser,
        GGetCurrentUserData_getCurrentUser_userExercises,
        GGetCurrentUserData_getCurrentUser_userExercises_exercise,
        GGetCurrentUserData_getCurrentUser_userExercises_exercise_program,
        GGetCurrentUserData_getCurrentUser_userExercises_exercise_program_category,
        GGetCurrentUserData_getCurrentUser_userPrograms,
        GGetCurrentUserData_getCurrentUser_userPrograms_program,
        GGetCurrentUserData_getCurrentUser_userPrograms_program_category;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_current_user.req.gql.dart'
    show GGetCurrentUserReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_current_user.var.gql.dart'
    show GGetCurrentUserVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercise.data.gql.dart'
    show GGetExerciseData, GGetExerciseData_getExercise;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercise.req.gql.dart'
    show GGetExerciseReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercise.var.gql.dart'
    show GGetExerciseVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercises.data.gql.dart'
    show
        GGetExercisesData,
        GGetExercisesData_getExercises,
        GGetExercisesData_getExercises_items,
        GGetExercisesData_getExercises_items_program,
        GGetExercisesData_getExercises_items_program_category,
        GGetExercisesData_getExercises_meta;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercises.req.gql.dart'
    show GGetExercisesReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_exercises.var.gql.dart'
    show GGetExercisesVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_home_overview.data.gql.dart'
    show GGetHomeOverviewData, GGetHomeOverviewData_getHomeOverview;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_home_overview.req.gql.dart'
    show GGetHomeOverviewReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_home_overview.var.gql.dart'
    show GGetHomeOverviewVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inbox.data.gql.dart'
    show GGetInboxData, GGetInboxData_getInbox, GGetInboxData_getInbox_user;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inbox.req.gql.dart'
    show GGetInboxReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inbox.var.gql.dart'
    show GGetInboxVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inboxes.data.gql.dart'
    show
        GGetInboxesData,
        GGetInboxesData_getInboxes,
        GGetInboxesData_getInboxes_items,
        GGetInboxesData_getInboxes_items_user,
        GGetInboxesData_getInboxes_meta;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inboxes.req.gql.dart'
    show GGetInboxesReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inboxes.var.gql.dart'
    show GGetInboxesVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_program.data.gql.dart'
    show
        GGetProgramData,
        GGetProgramData_getProgram,
        GGetProgramData_getProgram_category;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_program.req.gql.dart'
    show GGetProgramReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_program.var.gql.dart'
    show GGetProgramVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.data.gql.dart'
    show
        GGetProgramsData,
        GGetProgramsData_getPrograms,
        GGetProgramsData_getPrograms_items,
        GGetProgramsData_getPrograms_items_category,
        GGetProgramsData_getPrograms_meta;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart'
    show GGetProgramsReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.var.gql.dart'
    show GGetProgramsVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_support.data.gql.dart'
    show
        GGetSupportData,
        GGetSupportData_getSupport,
        GGetSupportData_getSupport_user;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_support.req.gql.dart'
    show GGetSupportReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_support.var.gql.dart'
    show GGetSupportVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_supports.data.gql.dart'
    show
        GGetSupportsData,
        GGetSupportsData_getSupports,
        GGetSupportsData_getSupports_items,
        GGetSupportsData_getSupports_items_user,
        GGetSupportsData_getSupports_meta;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_supports.req.gql.dart'
    show GGetSupportsReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_supports.var.gql.dart'
    show GGetSupportsVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_top_users_program.data.gql.dart'
    show
        GGetTopUsersProgramData,
        GGetTopUsersProgramData_getTopUsersProgram,
        GGetTopUsersProgramData_getTopUsersProgram_items,
        GGetTopUsersProgramData_getTopUsersProgram_meta;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_top_users_program.req.gql.dart'
    show GGetTopUsersProgramReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_top_users_program.var.gql.dart'
    show GGetTopUsersProgramVars;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_users.data.gql.dart'
    show
        GGetUsersData,
        GGetUsersData_getUsers,
        GGetUsersData_getUsers_items,
        GGetUsersData_getUsers_meta;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_users.req.gql.dart'
    show GGetUsersReq;
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_users.var.gql.dart'
    show GGetUsersVars;
import 'package:web_admin_fitness/global/utils/date_serializer.dart'
    show DateSerializer;

part 'serializers.gql.g.dart';

final SerializersBuilder _serializersBuilder = _$serializers.toBuilder()
  ..add(OperationSerializer())
  ..add(DateSerializer())
  ..addPlugin(StandardJsonPlugin());
@SerializersFor([
  GCategoryData,
  GCategoryReq,
  GCategoryVars,
  GChangePasswordData,
  GChangePasswordData_changePassword,
  GChangePasswordInputDto,
  GChangePasswordReq,
  GChangePasswordVars,
  GDeleteCategoryData,
  GDeleteCategoryData_deleteCategory,
  GDeleteCategoryReq,
  GDeleteCategoryVars,
  GDeleteExerciseData,
  GDeleteExerciseData_deleteExercise,
  GDeleteExerciseReq,
  GDeleteExerciseVars,
  GDeleteInboxData,
  GDeleteInboxData_deleteInbox,
  GDeleteInboxReq,
  GDeleteInboxVars,
  GDeleteProgramData,
  GDeleteProgramData_deleteProgram,
  GDeleteProgramReq,
  GDeleteProgramVars,
  GDeleteUserData,
  GDeleteUserData_deleteUser,
  GDeleteUserReq,
  GDeleteUserVars,
  GExerciseData,
  GExerciseData_program,
  GExerciseData_program_category,
  GExerciseReq,
  GExerciseVars,
  GFILTER_OPERATOR,
  GFilterDto,
  GGetCategoriesData,
  GGetCategoriesData_getCategories,
  GGetCategoriesData_getCategories_items,
  GGetCategoriesData_getCategories_meta,
  GGetCategoriesReq,
  GGetCategoriesVars,
  GGetCategoryData,
  GGetCategoryData_getCategory,
  GGetCategoryReq,
  GGetCategoryVars,
  GGetCurrentUserData,
  GGetCurrentUserData_getCurrentUser,
  GGetCurrentUserData_getCurrentUser_userExercises,
  GGetCurrentUserData_getCurrentUser_userExercises_exercise,
  GGetCurrentUserData_getCurrentUser_userExercises_exercise_program,
  GGetCurrentUserData_getCurrentUser_userExercises_exercise_program_category,
  GGetCurrentUserData_getCurrentUser_userPrograms,
  GGetCurrentUserData_getCurrentUser_userPrograms_program,
  GGetCurrentUserData_getCurrentUser_userPrograms_program_category,
  GGetCurrentUserReq,
  GGetCurrentUserVars,
  GGetExerciseData,
  GGetExerciseData_getExercise,
  GGetExerciseReq,
  GGetExerciseVars,
  GGetExercisesData,
  GGetExercisesData_getExercises,
  GGetExercisesData_getExercises_items,
  GGetExercisesData_getExercises_items_program,
  GGetExercisesData_getExercises_items_program_category,
  GGetExercisesData_getExercises_meta,
  GGetExercisesReq,
  GGetExercisesVars,
  GGetHomeOverviewData,
  GGetHomeOverviewData_getHomeOverview,
  GGetHomeOverviewReq,
  GGetHomeOverviewVars,
  GGetInboxData,
  GGetInboxData_getInbox,
  GGetInboxData_getInbox_user,
  GGetInboxReq,
  GGetInboxVars,
  GGetInboxesData,
  GGetInboxesData_getInboxes,
  GGetInboxesData_getInboxes_items,
  GGetInboxesData_getInboxes_items_user,
  GGetInboxesData_getInboxes_meta,
  GGetInboxesReq,
  GGetInboxesVars,
  GGetProgramData,
  GGetProgramData_getProgram,
  GGetProgramData_getProgram_category,
  GGetProgramReq,
  GGetProgramVars,
  GGetProgramsData,
  GGetProgramsData_getPrograms,
  GGetProgramsData_getPrograms_items,
  GGetProgramsData_getPrograms_items_category,
  GGetProgramsData_getPrograms_meta,
  GGetProgramsReq,
  GGetProgramsVars,
  GGetSupportData,
  GGetSupportData_getSupport,
  GGetSupportData_getSupport_user,
  GGetSupportReq,
  GGetSupportVars,
  GGetSupportsData,
  GGetSupportsData_getSupports,
  GGetSupportsData_getSupports_items,
  GGetSupportsData_getSupports_items_user,
  GGetSupportsData_getSupports_meta,
  GGetSupportsReq,
  GGetSupportsVars,
  GGetTopUsersProgramData,
  GGetTopUsersProgramData_getTopUsersProgram,
  GGetTopUsersProgramData_getTopUsersProgram_items,
  GGetTopUsersProgramData_getTopUsersProgram_meta,
  GGetTopUsersProgramReq,
  GGetTopUsersProgramVars,
  GGetUsersData,
  GGetUsersData_getUsers,
  GGetUsersData_getUsers_items,
  GGetUsersData_getUsers_meta,
  GGetUsersReq,
  GGetUsersVars,
  GIExerciseData,
  GIExerciseData_program,
  GIExerciseData_program_category,
  GIExerciseReq,
  GIExerciseVars,
  GISupportData,
  GISupportData_user,
  GISupportReq,
  GISupportVars,
  GInboxData,
  GInboxData_user,
  GInboxReq,
  GInboxVars,
  GLoginData,
  GLoginData_login,
  GLoginData_login_user,
  GLoginInputDto,
  GLoginReq,
  GLoginVars,
  GLogoutData,
  GLogoutData_logout,
  GLogoutReq,
  GLogoutVars,
  GMetaData,
  GMetaReq,
  GMetaVars,
  GProgramData,
  GProgramData_category,
  GProgramReq,
  GProgramVars,
  GQueryFilterDto,
  GRefreshTokenData,
  GRefreshTokenData_refreshToken,
  GRefreshTokenReq,
  GRefreshTokenVars,
  GRegisterData,
  GRegisterData_register,
  GRegisterInputDto,
  GRegisterReq,
  GRegisterVars,
  GSupportData,
  GSupportData_user,
  GSupportReq,
  GSupportVars,
  GUpsertCategoryData,
  GUpsertCategoryData_upsertCategory,
  GUpsertCategoryInputDto,
  GUpsertCategoryReq,
  GUpsertCategoryVars,
  GUpsertExerciseData,
  GUpsertExerciseData_upsertExercise,
  GUpsertExerciseInputDto,
  GUpsertExerciseReq,
  GUpsertExerciseVars,
  GUpsertInboxInputDto,
  GUpsertProgramData,
  GUpsertProgramData_upsertProgram,
  GUpsertProgramInputDto,
  GUpsertProgramReq,
  GUpsertProgramVars,
  GUpsertSupportData,
  GUpsertSupportData_upsertSupport,
  GUpsertSupportData_upsertSupport_user,
  GUpsertSupportInputDto,
  GUpsertSupportReq,
  GUpsertSupportVars,
  GUpsertUserData,
  GUpsertUserData_upsertUser,
  GUpsertUserExerciseInputDto,
  GUpsertUserInputDto,
  GUpsertUserProgramInputDto,
  GUpsertUserReq,
  GUpsertUserStatisticsInputDto,
  GUpsertUserVars,
  GUserData,
  GUserReq,
  GUserStatisticsData,
  GUserStatisticsReq,
  GUserStatisticsVars,
  GUserVars,
])
final Serializers serializers = _serializersBuilder.build();
