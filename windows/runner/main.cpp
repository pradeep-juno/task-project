#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>
#include "flutter_window.h"
#include "utils.h"

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
        _In_ wchar_t *command_line, _In_ int show_command) {
if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
CreateAndAttachConsole();
}

::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

flutter::DartProject project(L"data");
std::vector<std::string> command_line_arguments = GetCommandLineArguments();
project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

FlutterWindow window(project);

// Get monitor information for fullscreen
MONITORINFO mi = {sizeof(mi)};
HMONITOR hMonitor = MonitorFromWindow(nullptr, MONITOR_DEFAULTTONEAREST);
if (GetMonitorInfo(hMonitor, &mi)) {
DWORD style = GetWindowLong(nullptr, GWL_STYLE);
style &= ~(WS_CAPTION | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX);
SetWindowLong(nullptr, GWL_STYLE, style);

DWORD exStyle = GetWindowLong(nullptr, GWL_EXSTYLE);
exStyle &= ~(WS_EX_DLGMODALFRAME | WS_EX_CLIENTEDGE | WS_EX_STATICEDGE);
SetWindowLong(nullptr, GWL_EXSTYLE, exStyle);

SetWindowPos(nullptr, HWND_TOP, mi.rcMonitor.left, mi.rcMonitor.top,
mi.rcMonitor.right - mi.rcMonitor.left,
mi.rcMonitor.bottom - mi.rcMonitor.top,
SWP_NOZORDER | SWP_FRAMECHANGED);
}

if (!window.Create(L"JK Event Management", Win32Window::Point(0, 0),
Win32Window::Size(mi.rcMonitor.right - mi.rcMonitor.left,
mi.rcMonitor.bottom - mi.rcMonitor.top))) {
return EXIT_FAILURE;
}

window.SetQuitOnClose(true);

::MSG msg;
while (::GetMessage(&msg, nullptr, 0, 0)) {
::TranslateMessage(&msg);
::DispatchMessage(&msg);
}

::CoUninitialize();
return EXIT_SUCCESS;
}
