#ifndef BT_LIBRARY_HPP
#define BT_LIBRARY_HPP

#ifdef BUILD_DLL
#define API __declspec(dllexport)
#else
#define API __declspec(dllimport)
#endif

API void test();

#endif //BT_LIBRARY_HPP
