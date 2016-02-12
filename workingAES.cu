#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#define FALSE 0
#define TRUE 1
#define STATE_SIZE 16
#define NUM_STATE_BUFFER 33553920 
#define MAX_BUFFER_LENGTH STATE_SIZE*NUM_STATE_BUFFER


typedef unsigned char uChar;

/*Implementacion de la SBOX*/
 const uChar SBOX[256] = {
	0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76,
	0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0,
	0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15,
	0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75,
	0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84,
	0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF,
	0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8,
	0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2,
	0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73,
	0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB,
	0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79,
	0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08,
	0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A,
	0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E,
	0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF,
	0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16
};

__device__ const uChar CUDA_SBOX[256] = {
	0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76,
	0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0,
	0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15,
	0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75,
	0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84,
	0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF,
	0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8,
	0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2,
	0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73,
	0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB,
	0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79,
	0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08,
	0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A,
	0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E,
	0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF,
	0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16
};



//Utilizzata dal gestore di chiavi
const uChar RCON[256] = {
	0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a,
	0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39,
	0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a,
	0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8,
	0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef,
	0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc,
	0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b,
	0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3,
	0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94,
	0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20,
	0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63, 0xc6, 0x97, 0x35,
	0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd, 0x61, 0xc2, 0x9f,
	0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d, 0x01, 0x02, 0x04,
	0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36, 0x6c, 0xd8, 0xab, 0x4d, 0x9a, 0x2f, 0x5e, 0xbc, 0x63,
	0xc6, 0x97, 0x35, 0x6a, 0xd4, 0xb3, 0x7d, 0xfa, 0xef, 0xc5, 0x91, 0x39, 0x72, 0xe4, 0xd3, 0xbd,
	0x61, 0xc2, 0x9f, 0x25, 0x4a, 0x94, 0x33, 0x66, 0xcc, 0x83, 0x1d, 0x3a, 0x74, 0xe8, 0xcb, 0x8d
};

/*Tablas necesarias para la multiplicacion de matrices en la etapa MixColumns*/
__device__ const uChar GM2[256] = {
	0x00, 0x02, 0x04, 0x06, 0x08, 0x0a, 0x0c, 0x0e, 0x10, 0x12, 0x14, 0x16, 0x18, 0x1a, 0x1c, 0x1e,
	0x20, 0x22, 0x24, 0x26, 0x28, 0x2a, 0x2c, 0x2e, 0x30, 0x32, 0x34, 0x36, 0x38, 0x3a, 0x3c, 0x3e,
	0x40, 0x42, 0x44, 0x46, 0x48, 0x4a, 0x4c, 0x4e, 0x50, 0x52, 0x54, 0x56, 0x58, 0x5a, 0x5c, 0x5e,
	0x60, 0x62, 0x64, 0x66, 0x68, 0x6a, 0x6c, 0x6e, 0x70, 0x72, 0x74, 0x76, 0x78, 0x7a, 0x7c, 0x7e,
	0x80, 0x82, 0x84, 0x86, 0x88, 0x8a, 0x8c, 0x8e, 0x90, 0x92, 0x94, 0x96, 0x98, 0x9a, 0x9c, 0x9e,
	0xa0, 0xa2, 0xa4, 0xa6, 0xa8, 0xaa, 0xac, 0xae, 0xb0, 0xb2, 0xb4, 0xb6, 0xb8, 0xba, 0xbc, 0xbe,
	0xc0, 0xc2, 0xc4, 0xc6, 0xc8, 0xca, 0xcc, 0xce, 0xd0, 0xd2, 0xd4, 0xd6, 0xd8, 0xda, 0xdc, 0xde,
	0xe0, 0xe2, 0xe4, 0xe6, 0xe8, 0xea, 0xec, 0xee, 0xf0, 0xf2, 0xf4, 0xf6, 0xf8, 0xfa, 0xfc, 0xfe,
	0x1b, 0x19, 0x1f, 0x1d, 0x13, 0x11, 0x17, 0x15, 0x0b, 0x09, 0x0f, 0x0d, 0x03, 0x01, 0x07, 0x05,
	0x3b, 0x39, 0x3f, 0x3d, 0x33, 0x31, 0x37, 0x35, 0x2b, 0x29, 0x2f, 0x2d, 0x23, 0x21, 0x27, 0x25,
	0x5b, 0x59, 0x5f, 0x5d, 0x53, 0x51, 0x57, 0x55, 0x4b, 0x49, 0x4f, 0x4d, 0x43, 0x41, 0x47, 0x45,
	0x7b, 0x79, 0x7f, 0x7d, 0x73, 0x71, 0x77, 0x75, 0x6b, 0x69, 0x6f, 0x6d, 0x63, 0x61, 0x67, 0x65,
	0x9b, 0x99, 0x9f, 0x9d, 0x93, 0x91, 0x97, 0x95, 0x8b, 0x89, 0x8f, 0x8d, 0x83, 0x81, 0x87, 0x85,
	0xbb, 0xb9, 0xbf, 0xbd, 0xb3, 0xb1, 0xb7, 0xb5, 0xab, 0xa9, 0xaf, 0xad, 0xa3, 0xa1, 0xa7, 0xa5,
	0xdb, 0xd9, 0xdf, 0xdd, 0xd3, 0xd1, 0xd7, 0xd5, 0xcb, 0xc9, 0xcf, 0xcd, 0xc3, 0xc1, 0xc7, 0xc5,
	0xfb, 0xf9, 0xff, 0xfd, 0xf3, 0xf1, 0xf7, 0xf5, 0xeb, 0xe9, 0xef, 0xed, 0xe3, 0xe1, 0xe7, 0xe5
};

__device__ const uChar GM3[256] = {
	0x00, 0x03, 0x06, 0x05, 0x0c, 0x0f, 0x0a, 0x09, 0x18, 0x1b, 0x1e, 0x1d, 0x14, 0x17, 0x12, 0x11,
	0x30, 0x33, 0x36, 0x35, 0x3c, 0x3f, 0x3a, 0x39, 0x28, 0x2b, 0x2e, 0x2d, 0x24, 0x27, 0x22, 0x21,
	0x60, 0x63, 0x66, 0x65, 0x6c, 0x6f, 0x6a, 0x69, 0x78, 0x7b, 0x7e, 0x7d, 0x74, 0x77, 0x72, 0x71,
	0x50, 0x53, 0x56, 0x55, 0x5c, 0x5f, 0x5a, 0x59, 0x48, 0x4b, 0x4e, 0x4d, 0x44, 0x47, 0x42, 0x41,
	0xc0, 0xc3, 0xc6, 0xc5, 0xcc, 0xcf, 0xca, 0xc9, 0xd8, 0xdb, 0xde, 0xdd, 0xd4, 0xd7, 0xd2, 0xd1,
	0xf0, 0xf3, 0xf6, 0xf5, 0xfc, 0xff, 0xfa, 0xf9, 0xe8, 0xeb, 0xee, 0xed, 0xe4, 0xe7, 0xe2, 0xe1,
	0xa0, 0xa3, 0xa6, 0xa5, 0xac, 0xaf, 0xaa, 0xa9, 0xb8, 0xbb, 0xbe, 0xbd, 0xb4, 0xb7, 0xb2, 0xb1,
	0x90, 0x93, 0x96, 0x95, 0x9c, 0x9f, 0x9a, 0x99, 0x88, 0x8b, 0x8e, 0x8d, 0x84, 0x87, 0x82, 0x81,
	0x9b, 0x98, 0x9d, 0x9e, 0x97, 0x94, 0x91, 0x92, 0x83, 0x80, 0x85, 0x86, 0x8f, 0x8c, 0x89, 0x8a,
	0xab, 0xa8, 0xad, 0xae, 0xa7, 0xa4, 0xa1, 0xa2, 0xb3, 0xb0, 0xb5, 0xb6, 0xbf, 0xbc, 0xb9, 0xba,
	0xfb, 0xf8, 0xfd, 0xfe, 0xf7, 0xf4, 0xf1, 0xf2, 0xe3, 0xe0, 0xe5, 0xe6, 0xef, 0xec, 0xe9, 0xea,
	0xcb, 0xc8, 0xcd, 0xce, 0xc7, 0xc4, 0xc1, 0xc2, 0xd3, 0xd0, 0xd5, 0xd6, 0xdf, 0xdc, 0xd9, 0xda,
	0x5b, 0x58, 0x5d, 0x5e, 0x57, 0x54, 0x51, 0x52, 0x43, 0x40, 0x45, 0x46, 0x4f, 0x4c, 0x49, 0x4a,
	0x6b, 0x68, 0x6d, 0x6e, 0x67, 0x64, 0x61, 0x62, 0x73, 0x70, 0x75, 0x76, 0x7f, 0x7c, 0x79, 0x7a,
	0x3b, 0x38, 0x3d, 0x3e, 0x37, 0x34, 0x31, 0x32, 0x23, 0x20, 0x25, 0x26, 0x2f, 0x2c, 0x29, 0x2a,
	0x0b, 0x08, 0x0d, 0x0e, 0x07, 0x04, 0x01, 0x02, 0x13, 0x10, 0x15, 0x16, 0x1f, 0x1c, 0x19, 0x1a
};







uChar** state;
uChar plain_text[MAX_BUFFER_LENGTH];
uChar plain_textHEX[MAX_BUFFER_LENGTH];

//file per le statistiche
FILE *data;
long plain_text_size; //dimensione file di input

//----------PARAMETRI AES, QUI ASSEGNATI DI DEFAULT-------
int bits = 128; //tipo ci cifratura
int tot_rounds = 11;



int pass_lenght; //lunghezza della password
uChar password[16];
uChar expanded_key[176]; //chiave calcolata dallo schedule key
int allTestSuccess;



//----------------------FUNZIONI AUSILIARIE---------------
void printKey(uChar* in, int dim) {
	printf("Password: ");
	for (int i = 0; i < dim; ++i)
	{
		printf("%02x ", in[i] );
	}
	printf("\n" );
}

void printState(uChar** matrix) {
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 4; j++) {
			printf("%02x     ", matrix[i][j]);
		}
		printf("\n");
	}
	printf("\n");
}

void printStateInline(uChar** matrix) {
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 4; j++) {
			printf("%02x", matrix[j][i]);
		}

	}
	printf("\n");
}
/*
void initStateChar(char* file_name, int block_dim) {

	columns = block_dim / 32;
	state = malloc(rows * sizeof(uChar*));
	for (int i = 0; i < rows; i++) {
		state[i] = malloc(columns * sizeof(uChar));
	}
	FILE *fp;
	char ch;
	fp = fopen(file_name, "r");
	for (int i = 0; i < columns; i++) {
		for (int j = 0; j < rows; j++) {
			ch = fgetc(fp);
			if (ch == EOF) {
				state[j][i] = NULL;
			}
			else {
				state[j][i] = ch;
			}
		}
	}
	fclose(fp);
	printState(state);

}
*/
int getVal(char c)
{
	int rtVal = 0;

	if (c >= '0' && c <= '9')
	{
		rtVal = c - '0';
	}
	else
	{
		rtVal = c - 'a' + 10;
	}

	return rtVal;
}

void initStateHex( ) {

	for (int i = 0; i < MAX_BUFFER_LENGTH; i+=2) {
				plain_textHEX[i/2] = getVal(plain_text[i]) * 16 + getVal(plain_text[i + 1]);

			}
		
	

}



void readKey(char* file_name) {
	FILE *fr;

	fr = fopen (file_name, "r");
	char c;
	for (int i = 0; i < 16; ++i)
	{
		c = fgetc(fr);
		int val = getVal(c) * 16 + getVal(fgetc(fr));

		password[i] = val;


	}
	fclose(fr);

}
__device__ void CUDARotaWord(uChar* w, uChar n) {
    uChar tmp[4] = {w[0], w[1], w[2], w[3]};
    int w_it;

   
    for (w_it = 0; w_it < 4; w_it++) {
            w[w_it] = tmp[(w_it + n) % 4];
       
    }
}




//-------------------GESTORE DELLE CHIAVI----------------

void rotate(unsigned char *in) {
	unsigned char a;
	a = in[0];
	for (int i = 0; i < 3; i++)
		in[i] = in[i + 1];
	in[3] = a;
}

void schedule_core(unsigned char *in, unsigned char i) {
	char a;
	/* Rotate the input 8 bits to the left */
	rotate(in);
	/* Apply Rijndael's s-box on all 4 bytes */
	for (a = 0; a < 4; a++)
		in[a] = SBOX[in[a]];
	/* On just the first byte, add 2^i to the byte */
	in[0] ^= RCON[i];
}

void expand_key(uChar *in) {

	uChar t[4];
	/* c is 16 because the first sub-key is the user-supplied key */
	int c = 16;
	uChar i = 1;
	uChar a;
	memcpy(expanded_key, in, 16);
	//printKey(expanded_key, 16);
	//printf("%x\n", expanded_key[16] );

	/* We need 11 sets of sixteen bytes each for 128-bit mode */
	while (c < 176) {
		/* Copy the temporary variable over from the last 4-byte
		 * block */

		for (a = 0; a < 4; a++) {
			t[a] = expanded_key[a + c - 4];

		}
		/* Every four blocks (of four bytes),
		 * do a complex calculation */
		if (c % 16 == 0) {
			schedule_core(t, i);
			i++;
		}
		for (a = 0; a < 4; a++) {


			expanded_key[c] = expanded_key[c - 16] ^ t[a];
			c++;

		}
	}
	//printKey(expanded_key, 176);

}

//-------------------FUNZIONI AES------------------------

__device__ void addRoundKey(uChar state[4][4], int cur_round, uChar* expanded_keyGPU) {
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 4; j++) {
			int val = (cur_round * 16) + ((i * 4) + j);
			state[i][j] ^= expanded_keyGPU[val];

		}
	}


}


__device__ void shiftRows(uChar state[4][4]) {
    int state_col, w_it;
    uChar w[4];

    for (state_col = 1; state_col < 4; ++state_col) {
        for (w_it = 0; w_it < 4; ++w_it) w[w_it] = state[w_it][state_col];
        CUDARotaWord(w, state_col);
        for (w_it = 0; w_it < 4; ++w_it) state[w_it][state_col] = w[w_it];
    }
}



__device__ void subBytes(uChar state[4][4]) {
	int state_r, state_c, sbox_r, sbox_c;
	for (state_r = 0; state_r < 4; state_r++) {
		for (state_c = 0; state_c < 4; state_c++) {

			sbox_r = (state[state_r][state_c] & 0xf0) >> 4;
			sbox_c = state[state_r][state_c] & 0x0f;

			state[state_r][state_c] = CUDA_SBOX[sbox_r * 16 + sbox_c];

		}
	}
}



__device__ void mixColumns(uChar State[4][4]) {
    int fila, cols;
    uChar tmp[4];

  
       
            for (fila = 0; fila < 4; ++fila) {
                tmp[0] = GM2[State[fila][0]] ^ GM3[State[fila][1]] ^ State[fila][2] ^ State[fila][3];
                tmp[1] = State[fila][0] ^ GM2[State[fila][1]] ^ GM3[State[fila][2]] ^ State[fila][3];
                tmp[2] = State[fila][0] ^ State[fila][1] ^ GM2[State[fila][2]] ^ GM3[State[fila][3]];
                tmp[3] = GM3[State[fila][0]] ^ State[fila][1] ^ State[fila][2] ^ GM2[State[fila][3]];
                
                for (cols = 0; cols < 4; ++cols)State[fila][cols] = tmp[cols];
            }
        
    
}
__global__ void AES_Encrypt(uChar* Buffer_gpu, uChar* ExpandKey_gpu, int nStates, int rounds) {
    uChar State[4][4];

    int rounds_it, it;
    int thread_idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (thread_idx < nStates) {
        for (it = 0; it < 16; it++) {
            State[it / 4][it % 4] = Buffer_gpu[thread_idx * 16 + it];

        }
    
          	
          	
            addRoundKey(State, 0, ExpandKey_gpu);
           
            
            for (rounds_it = 1; rounds_it < 10; rounds_it++) {
                subBytes(State);
                shiftRows(State);
                mixColumns(State);
                addRoundKey(State, rounds_it, ExpandKey_gpu);
               
                
                
            }
            subBytes(State);
            shiftRows(State);
            addRoundKey(State, 10, ExpandKey_gpu);
       

        for (it = 0; it < 16; it++) {
            Buffer_gpu[thread_idx * 16 + it] = State[it / 4][it % 4];
        }

    }
    __syncthreads();
}

void readPlainText(char* file_name) {

	FILE *fp;

	

	fp = fopen ( file_name, "rb" );
	if ( !fp ) perror(file_name), exit(1);

	fseek( fp , 0L , SEEK_END);
	plain_text_size = ftell( fp );
	rewind( fp );

	/* allocate memory for entire content */
	//buffer = calloc( 1, plain_text_size + 1 );
	if ( !plain_text ) fclose(fp), fputs("memory alloc fails", stderr), exit(1);

	/* copy the file into the buffer */
	if ( 1 != fread(plain_text , plain_text_size, 1 , fp) )
		fclose(fp), free(plain_text), fputs("entire read fails", stderr), exit(1);

	/* do your work here, buffer is a string contains the whole text */

	fclose(fp);
	//printf("%s\n",buffer );

}


int checkResult(uChar * plain_text) {
	uChar result[] = "\x3a\xd7\x7b\xb4\x0d\x7a\x36\x60\xa8\x9e\xca\xf3\x24\x66\xef\x97";
	//printf("ciaoo\n");
	for (int i = 0; i < 16; i++) {	
			if (plain_text[i] != result[i]) return 0;
	}
	return 1;

}




int main(int argc, char** argv) {

	readPlainText("plainText.txt");
	uChar *Buffer_gpu, *ExpandKey_gpu;
	int nStatesInBuffer;
	

	int collect_data = FALSE;
	int show_all = FALSE;

	for (int i = 0; i < argc; i++)
	{

		if (strcmp(argv[i], "-s") == 0) {

			show_all = TRUE;
		}
		if (strcmp(argv[i], "-c" ) == 0) {
			//apre o crea il file per le statistiche
			data = fopen("scoresCPU.dat", "w");
			collect_data = TRUE;
		}
	}


	readKey("key.txt");
	expand_key(password);

/*
	//numero di test da eseguire su diverse lunghezze
	int vector_dim = 16 * 2;
	int num_test = 1;
	//long *test_sizes = malloc(num_test * sizeof(long));

	test_sizes[0] = 31134208;
	test_sizes[1] = vector_dim * 512;
	test_sizes[2] = vector_dim * 1024;
	test_sizes[3] = vector_dim * 2048;
	test_sizes[4] = vector_dim * 4096;
	test_sizes[5] = vector_dim * 8192;
	test_sizes[6] = vector_dim * 16384;


	//long double *test_res = malloc(num_test * sizeof(long double));
	for (int cur_test = 0; cur_test < num_test; cur_test++)	{
		long dim_test = test_sizes[cur_test] / 2;
		printf("TEST con dimensione %d\n", dim_test );
		allTestSuccess = 1;
		*/
		clock_t start, stop;
		start = clock();
	
		initStateHex();
		nStatesInBuffer = plain_text_size/16;
		cudaMalloc((void**) &Buffer_gpu, sizeof (uChar) * MAX_BUFFER_LENGTH);
       	cudaMalloc((void**) &ExpandKey_gpu, sizeof (uChar) * 176);

       	cudaMemcpy(ExpandKey_gpu, expanded_key, sizeof (uChar) *176, cudaMemcpyHostToDevice);
       	cudaMemcpy(Buffer_gpu, plain_textHEX, sizeof (uChar) * MAX_BUFFER_LENGTH, cudaMemcpyHostToDevice);	
		AES_Encrypt << <65535, 512 >> >(Buffer_gpu, ExpandKey_gpu, nStatesInBuffer, 11);
		cudaMemcpy(plain_textHEX, Buffer_gpu, sizeof (uChar) * MAX_BUFFER_LENGTH, cudaMemcpyDeviceToHost);
		printf("Risultato Test = %d\n",checkResult(plain_textHEX));
		for(int i=0;i<16;i++){
			printf("%x ", plain_textHEX[i]);
		}
		printf("\n");
		
		
		//allTestSuccess = allTestSuccess && checkResult(state);

	
		
		stop = clock();
		long double elapsed_time = (stop - start) / (double) CLOCKS_PER_SEC;
		printf("Time = %f sec\n",elapsed_time);
		//test_res[cur_test] = elapsed_time;
		//printf("Risultato test: %d\n", allTestSuccess );
	}

/*
	char string_data[5000];
	if (collect_data){
	for (int i = 0; i < num_test; ++i)	{
		char temp[100];
		sprintf(temp, "%d	%f\n", test_sizes[i] / 2, test_res[i]);
		strcat(string_data, temp);
	}

	 fprintf(data, "%s", string_data);


}
*/
	//initStateChar("text.txt", bits);

	//plot();


	//printKey();









