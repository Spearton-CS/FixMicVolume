using NAudio.CoreAudioApi;

using System.Runtime.InteropServices;

const float fixVolume = 1f;
StreamWriter logWriter;
try
{
    logWriter = new(File.Open("FixMicVolume.log", FileMode.Create, FileAccess.Write, FileShare.Read), System.Text.Encoding.UTF8)
    {
        AutoFlush = true
    };
}
catch
{
    logWriter = StreamWriter.Null;
}
if (args[0].Equals("noConsole", StringComparison.OrdinalIgnoreCase))
    ShowWindow(GetConsoleWindow(), 0);

Console.Title = "FixMicVolume";
Log($"Mic volume will be fixed at {(int)(fixVolume * 100)}%.");
Log("To close console press Ctrl+C\r\n");

try
{
    using MMDeviceEnumerator enumerator = new();
    using var defaultMicrophone = enumerator.GetDefaultAudioEndpoint(DataFlow.Capture, Role.Multimedia);

    Log($"Device under control: {defaultMicrophone.FriendlyName}");
    Log("Monitoring is started\r\n");

    while (true)
    {
        float volume = defaultMicrophone.AudioEndpointVolume.MasterVolumeLevelScalar;
        if (volume <= (fixVolume - 0.05f) || volume >= (fixVolume + 0.05f))
        {
            Log($"[{DateTime.Now:dd:hh:mm:ss}] Fix volume from {(int)(volume * 100)}% to {(int)(fixVolume * 100)}%");
            defaultMicrophone.AudioEndpointVolume.MasterVolumeLevelScalar = fixVolume;
        }

        Thread.Sleep(500);
    }
}
catch (System.Runtime.InteropServices.COMException ex)
{
    Log($"\r\nDevice access exception. Make sure, that mic is plugged and available.\nExpected exception: {ex.Message}");
    logWriter.Dispose();
    Console.ReadKey();
}
catch (Exception ex)
{
    Log($"\r\nUnexpected exception: {ex.Message}");
    logWriter.Dispose();
    Console.ReadKey();
}

void Log(string line)
{
    Console.WriteLine(line);
    logWriter.WriteLine(line);
}

[DllImport("kernel32.dll")]
static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);