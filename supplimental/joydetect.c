#include <stdio.h> 
#include <unistd.h>
#include <sys/fcntl.h>
#include <linux/joystick.h>

int main(int argc, char **argv)
{
	char jcaps[2];
	char jname[128] = { 0 };

	int jhandle = open(argv[1], O_RDONLY);
	
	if(jhandle<0)
	{
		fprintf(stderr, "Couldn't open joystick device\n");
		return 1;
	}

	ioctl (jhandle, JSIOCGAXES, &jcaps[0]);
	ioctl (jhandle, JSIOCGBUTTONS, &jcaps[1]);
	ioctl (jhandle, JSIOCGNAME(128), &jname);
	close(jhandle);

        printf("Name: %s\n",jname);

	return 0;
}

