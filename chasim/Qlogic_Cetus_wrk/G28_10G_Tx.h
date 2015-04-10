extern "C" __declspec(dllexport) long AMI_Init(double *ip, long rs, long ag, double si, double bt, char *pi, char **po, void **mh, char **msg);
extern "C" __declspec(dllexport) long AMI_GetWave(double *wave, long wave_size, double *clock_times, char **apo, void *mh);

