// Matrix Orbital LCD functions for BeOS

#include "MatrixOrbital.h"

#define Esc	"\x0FE",1

char temp[64];

void MOSendText(char *Text)
{
	myPort.Write(Text, strlen(Text));
}

void MOSendCode(char *Code, int Len)
{
	myPort.Write(Esc);
	myPort.Write(Code, Len);
}

void MOSetLineWrapping(bool LineWrap)
{
	if (LineWrap) MOSendCode("C",1);
	 else MOSendCode("D",1);
}

void MOSetScrolling(bool Scrolling)
{
	if (Scrolling) MOSendCode("Q",1);
	 else MOSendCode("R",1);
}

void MOSetBacklight(bool Backlight)
{
	if (Backlight) MOSendCode("B\x000",2);
	 else MOSendCode("F",1);
}

void MOSetBlink(bool Blink)
{
	if (Blink) MOSendCode("S",1);
	 else MOSendCode("T",1);
}

void MOClearDisplay(void)
{
	MOSendCode("X",1);
}

void MOSetContrast(int Contrast)
{
	temp[0]='P';
	temp[1]=Contrast;
	MOSendCode(temp,2);
}

void MOSetCursorDisplay(int CursorDisplay)
{
	if (CursorDisplay) MOSendCode("J",1);
	 else MOSendCode("K",1);
}

void MOMoveCursorLeft(void)
{
	MOSendCode("L",1);
}

void MOMoveCursorRight(void)
{
	MOSendCode("M",1);
}

void MOCreateCustom(int Char, char Matrix[7])
{
	temp[0]='N';
	temp[1]=Char;
	temp[2]=Matrix[0];
	temp[3]=Matrix[1];
	temp[4]=Matrix[2];
	temp[5]=Matrix[3];
	temp[6]=Matrix[4];
	temp[7]=Matrix[5];
	temp[8]=Matrix[6];
	temp[9]=Matrix[7];
	MOSendCode(temp,10);
}

void MOSetGeneralPurpose(bool GeneralPurpose)
{
	if (GeneralPurpose) MOSendCode("V",1);
	 else MOSendCode("W",1);
}

void MOSetCursorPosition(int Column, int Row)
{
	temp[0]='G';
	temp[1]=Column;
	temp[2]=Row;
	MOSendCode(temp,3);
}

void MOHome(void)
{
	MOSendCode("H",1);
}

void MOInitLargeDigits(void)
{
	MOSendCode("n",1);
}

void MOPlaceLargeDigit(int Column, char Digit)
{
	temp[0]='#';
	temp[1]=Column;
	temp[2]=Digit;
	MOSendCode(temp,3);
}

void MOInitHorizBar(void)
{
	MOSendCode("h",1);
}

void MOMakeHorizBar(int Column, int Row, int Dir, int Len)
{
	temp[0]=0x07c;
	temp[1]=Column;
	temp[2]=Row;
	temp[3]=Dir;
	temp[4]=Len;
	MOSendCode(temp,5);
}

void MOInitVertBar(int Thick)
{
	if (Thick) MOSendCode("v",1);
	 else MOSendCode("s",1);
}

void MOMakeVertBar(int Column, int Len)
{
	temp[0]=0x03d;
	temp[1]=Column;
	temp[2]=Len;
	MOSendCode(temp,3);
}