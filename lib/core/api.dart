import 'package:dio/dio.dart';

const kBaseUrl = 'https://api.themoviedb.org/3';

const kApiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiNmY1YWIxZmU2YzE3MWE2MWU1ZmIxMmE1YTBiNGVmYSIsInN1YiI6IjYxZTU5NjQ2NmFhOGUwMDAxYzQxMjEwYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.TxLhBL6NoMunFrQIreHI765002cwW00hicpz-DfnxYQ';
// const kApiKey = 'b6f5ab1fe6c171a61e5fb12a5a0b4efa';
const kServerError = "Failed to connect to the server. Try again later.";

final kDioOptions = BaseOptions(
  baseUrl: kBaseUrl,
  connectTimeout: 5000,
  receiveTimeout: 3000,
  contentType: 'application/json;charset=utf-8',
  headers: {'Authorization': 'Bearer $kApiKey'},
);