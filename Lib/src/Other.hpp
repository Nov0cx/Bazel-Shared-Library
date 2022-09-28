#ifndef BT_OTHER_HPP
#define BT_OTHER_HPP

#ifdef BUILD_DLL
#define API __declspec(dllexport)
#else
#define API __declspec(dllimport)
#endif

void yes();

#endif //BT_OTHER_HPP
