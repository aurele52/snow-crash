
int main(int argc, char **argv) {
	int i = 0;
	while (argv[1][i]) {
		argv[1][i] = argv[1][i] - i;
		write(1,&argv[1][i],1);
		i++;
}
write(1,"\n", 1);
}
