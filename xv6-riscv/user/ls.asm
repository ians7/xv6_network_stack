
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	32a080e7          	jalr	810(ra) # 336 <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	00000097          	auipc	ra,0x0
  3c:	2fe080e7          	jalr	766(ra) # 336 <strlen>
  40:	47b5                	li	a5,13
  42:	00a7f863          	bgeu	a5,a0,52 <fmtname+0x52>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  46:	8526                	mv	a0,s1
  48:	60e2                	ld	ra,24(sp)
  4a:	6442                	ld	s0,16(sp)
  4c:	64a2                	ld	s1,8(sp)
  4e:	6105                	addi	sp,sp,32
  50:	8082                	ret
  52:	e04a                	sd	s2,0(sp)
  memmove(buf, p, strlen(p));
  54:	8526                	mv	a0,s1
  56:	00000097          	auipc	ra,0x0
  5a:	2e0080e7          	jalr	736(ra) # 336 <strlen>
  5e:	862a                	mv	a2,a0
  60:	85a6                	mv	a1,s1
  62:	00001517          	auipc	a0,0x1
  66:	54e50513          	addi	a0,a0,1358 # 15b0 <buf.0>
  6a:	00000097          	auipc	ra,0x0
  6e:	454080e7          	jalr	1108(ra) # 4be <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  72:	8526                	mv	a0,s1
  74:	00000097          	auipc	ra,0x0
  78:	2c2080e7          	jalr	706(ra) # 336 <strlen>
  7c:	892a                	mv	s2,a0
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	2b6080e7          	jalr	694(ra) # 336 <strlen>
  88:	02091793          	slli	a5,s2,0x20
  8c:	9381                	srli	a5,a5,0x20
  8e:	4639                	li	a2,14
  90:	9e09                	subw	a2,a2,a0
  92:	02000593          	li	a1,32
  96:	00001517          	auipc	a0,0x1
  9a:	51a50513          	addi	a0,a0,1306 # 15b0 <buf.0>
  9e:	953e                	add	a0,a0,a5
  a0:	00000097          	auipc	ra,0x0
  a4:	2c2080e7          	jalr	706(ra) # 362 <memset>
  return buf;
  a8:	00001497          	auipc	s1,0x1
  ac:	50848493          	addi	s1,s1,1288 # 15b0 <buf.0>
  b0:	6902                	ld	s2,0(sp)
  b2:	bf51                	j	46 <fmtname+0x46>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	da010113          	addi	sp,sp,-608
  b8:	24113c23          	sd	ra,600(sp)
  bc:	24813823          	sd	s0,592(sp)
  c0:	25213023          	sd	s2,576(sp)
  c4:	1480                	addi	s0,sp,608
  c6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  c8:	4581                	li	a1,0
  ca:	00000097          	auipc	ra,0x0
  ce:	4ea080e7          	jalr	1258(ra) # 5b4 <open>
  d2:	06054b63          	bltz	a0,148 <ls+0x94>
  d6:	24913423          	sd	s1,584(sp)
  da:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  dc:	da840593          	addi	a1,s0,-600
  e0:	00000097          	auipc	ra,0x0
  e4:	4ec080e7          	jalr	1260(ra) # 5cc <fstat>
  e8:	06054b63          	bltz	a0,15e <ls+0xaa>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  ec:	db041783          	lh	a5,-592(s0)
  f0:	4705                	li	a4,1
  f2:	08e78863          	beq	a5,a4,182 <ls+0xce>
  f6:	37f9                	addiw	a5,a5,-2
  f8:	17c2                	slli	a5,a5,0x30
  fa:	93c1                	srli	a5,a5,0x30
  fc:	02f76663          	bltu	a4,a5,128 <ls+0x74>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 100:	854a                	mv	a0,s2
 102:	00000097          	auipc	ra,0x0
 106:	efe080e7          	jalr	-258(ra) # 0 <fmtname>
 10a:	85aa                	mv	a1,a0
 10c:	db843703          	ld	a4,-584(s0)
 110:	dac42683          	lw	a3,-596(s0)
 114:	db041603          	lh	a2,-592(s0)
 118:	00001517          	auipc	a0,0x1
 11c:	c4850513          	addi	a0,a0,-952 # d60 <ithread_join+0x80>
 120:	00001097          	auipc	ra,0x1
 124:	802080e7          	jalr	-2046(ra) # 922 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 128:	8526                	mv	a0,s1
 12a:	00000097          	auipc	ra,0x0
 12e:	472080e7          	jalr	1138(ra) # 59c <close>
 132:	24813483          	ld	s1,584(sp)
}
 136:	25813083          	ld	ra,600(sp)
 13a:	25013403          	ld	s0,592(sp)
 13e:	24013903          	ld	s2,576(sp)
 142:	26010113          	addi	sp,sp,608
 146:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 148:	864a                	mv	a2,s2
 14a:	00001597          	auipc	a1,0x1
 14e:	be658593          	addi	a1,a1,-1050 # d30 <ithread_join+0x50>
 152:	4509                	li	a0,2
 154:	00000097          	auipc	ra,0x0
 158:	7a0080e7          	jalr	1952(ra) # 8f4 <fprintf>
    return;
 15c:	bfe9                	j	136 <ls+0x82>
    fprintf(2, "ls: cannot stat %s\n", path);
 15e:	864a                	mv	a2,s2
 160:	00001597          	auipc	a1,0x1
 164:	be858593          	addi	a1,a1,-1048 # d48 <ithread_join+0x68>
 168:	4509                	li	a0,2
 16a:	00000097          	auipc	ra,0x0
 16e:	78a080e7          	jalr	1930(ra) # 8f4 <fprintf>
    close(fd);
 172:	8526                	mv	a0,s1
 174:	00000097          	auipc	ra,0x0
 178:	428080e7          	jalr	1064(ra) # 59c <close>
    return;
 17c:	24813483          	ld	s1,584(sp)
 180:	bf5d                	j	136 <ls+0x82>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 182:	854a                	mv	a0,s2
 184:	00000097          	auipc	ra,0x0
 188:	1b2080e7          	jalr	434(ra) # 336 <strlen>
 18c:	2541                	addiw	a0,a0,16
 18e:	20000793          	li	a5,512
 192:	00a7fb63          	bgeu	a5,a0,1a8 <ls+0xf4>
      printf("ls: path too long\n");
 196:	00001517          	auipc	a0,0x1
 19a:	bda50513          	addi	a0,a0,-1062 # d70 <ithread_join+0x90>
 19e:	00000097          	auipc	ra,0x0
 1a2:	784080e7          	jalr	1924(ra) # 922 <printf>
      break;
 1a6:	b749                	j	128 <ls+0x74>
 1a8:	23313c23          	sd	s3,568(sp)
    strcpy(buf, path);
 1ac:	85ca                	mv	a1,s2
 1ae:	dd040513          	addi	a0,s0,-560
 1b2:	00000097          	auipc	ra,0x0
 1b6:	134080e7          	jalr	308(ra) # 2e6 <strcpy>
    p = buf+strlen(buf);
 1ba:	dd040513          	addi	a0,s0,-560
 1be:	00000097          	auipc	ra,0x0
 1c2:	178080e7          	jalr	376(ra) # 336 <strlen>
 1c6:	1502                	slli	a0,a0,0x20
 1c8:	9101                	srli	a0,a0,0x20
 1ca:	dd040793          	addi	a5,s0,-560
 1ce:	00a78733          	add	a4,a5,a0
 1d2:	893a                	mv	s2,a4
    *p++ = '/';
 1d4:	00170793          	addi	a5,a4,1
 1d8:	89be                	mv	s3,a5
 1da:	02f00793          	li	a5,47
 1de:	00f70023          	sb	a5,0(a4)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1e2:	a819                	j	1f8 <ls+0x144>
        printf("ls: cannot stat %s\n", buf);
 1e4:	dd040593          	addi	a1,s0,-560
 1e8:	00001517          	auipc	a0,0x1
 1ec:	b6050513          	addi	a0,a0,-1184 # d48 <ithread_join+0x68>
 1f0:	00000097          	auipc	ra,0x0
 1f4:	732080e7          	jalr	1842(ra) # 922 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f8:	4641                	li	a2,16
 1fa:	dc040593          	addi	a1,s0,-576
 1fe:	8526                	mv	a0,s1
 200:	00000097          	auipc	ra,0x0
 204:	38c080e7          	jalr	908(ra) # 58c <read>
 208:	47c1                	li	a5,16
 20a:	04f51f63          	bne	a0,a5,268 <ls+0x1b4>
      if(de.inum == 0)
 20e:	dc045783          	lhu	a5,-576(s0)
 212:	d3fd                	beqz	a5,1f8 <ls+0x144>
      memmove(p, de.name, DIRSIZ);
 214:	4639                	li	a2,14
 216:	dc240593          	addi	a1,s0,-574
 21a:	854e                	mv	a0,s3
 21c:	00000097          	auipc	ra,0x0
 220:	2a2080e7          	jalr	674(ra) # 4be <memmove>
      p[DIRSIZ] = 0;
 224:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 228:	da840593          	addi	a1,s0,-600
 22c:	dd040513          	addi	a0,s0,-560
 230:	00000097          	auipc	ra,0x0
 234:	1fa080e7          	jalr	506(ra) # 42a <stat>
 238:	fa0546e3          	bltz	a0,1e4 <ls+0x130>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 23c:	dd040513          	addi	a0,s0,-560
 240:	00000097          	auipc	ra,0x0
 244:	dc0080e7          	jalr	-576(ra) # 0 <fmtname>
 248:	85aa                	mv	a1,a0
 24a:	db843703          	ld	a4,-584(s0)
 24e:	dac42683          	lw	a3,-596(s0)
 252:	db041603          	lh	a2,-592(s0)
 256:	00001517          	auipc	a0,0x1
 25a:	b3250513          	addi	a0,a0,-1230 # d88 <ithread_join+0xa8>
 25e:	00000097          	auipc	ra,0x0
 262:	6c4080e7          	jalr	1732(ra) # 922 <printf>
 266:	bf49                	j	1f8 <ls+0x144>
 268:	23813983          	ld	s3,568(sp)
 26c:	bd75                	j	128 <ls+0x74>

000000000000026e <main>:

int
main(int argc, char *argv[])
{
 26e:	1101                	addi	sp,sp,-32
 270:	ec06                	sd	ra,24(sp)
 272:	e822                	sd	s0,16(sp)
 274:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 276:	4785                	li	a5,1
 278:	02a7db63          	bge	a5,a0,2ae <main+0x40>
 27c:	e426                	sd	s1,8(sp)
 27e:	e04a                	sd	s2,0(sp)
 280:	00858493          	addi	s1,a1,8
 284:	ffe5091b          	addiw	s2,a0,-2
 288:	02091793          	slli	a5,s2,0x20
 28c:	01d7d913          	srli	s2,a5,0x1d
 290:	05c1                	addi	a1,a1,16
 292:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 294:	6088                	ld	a0,0(s1)
 296:	00000097          	auipc	ra,0x0
 29a:	e1e080e7          	jalr	-482(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 29e:	04a1                	addi	s1,s1,8
 2a0:	ff249ae3          	bne	s1,s2,294 <main+0x26>
  exit(0);
 2a4:	4501                	li	a0,0
 2a6:	00000097          	auipc	ra,0x0
 2aa:	2ce080e7          	jalr	718(ra) # 574 <exit>
 2ae:	e426                	sd	s1,8(sp)
 2b0:	e04a                	sd	s2,0(sp)
    ls(".");
 2b2:	00001517          	auipc	a0,0x1
 2b6:	ae650513          	addi	a0,a0,-1306 # d98 <ithread_join+0xb8>
 2ba:	00000097          	auipc	ra,0x0
 2be:	dfa080e7          	jalr	-518(ra) # b4 <ls>
    exit(0);
 2c2:	4501                	li	a0,0
 2c4:	00000097          	auipc	ra,0x0
 2c8:	2b0080e7          	jalr	688(ra) # 574 <exit>

00000000000002cc <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2d4:	00000097          	auipc	ra,0x0
 2d8:	f9a080e7          	jalr	-102(ra) # 26e <main>
  exit(0);
 2dc:	4501                	li	a0,0
 2de:	00000097          	auipc	ra,0x0
 2e2:	296080e7          	jalr	662(ra) # 574 <exit>

00000000000002e6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ee:	87aa                	mv	a5,a0
 2f0:	0585                	addi	a1,a1,1
 2f2:	0785                	addi	a5,a5,1
 2f4:	fff5c703          	lbu	a4,-1(a1)
 2f8:	fee78fa3          	sb	a4,-1(a5)
 2fc:	fb75                	bnez	a4,2f0 <strcpy+0xa>
    ;
  return os;
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret

0000000000000306 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 306:	1141                	addi	sp,sp,-16
 308:	e406                	sd	ra,8(sp)
 30a:	e022                	sd	s0,0(sp)
 30c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 30e:	00054783          	lbu	a5,0(a0)
 312:	cb91                	beqz	a5,326 <strcmp+0x20>
 314:	0005c703          	lbu	a4,0(a1)
 318:	00f71763          	bne	a4,a5,326 <strcmp+0x20>
    p++, q++;
 31c:	0505                	addi	a0,a0,1
 31e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 320:	00054783          	lbu	a5,0(a0)
 324:	fbe5                	bnez	a5,314 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 326:	0005c503          	lbu	a0,0(a1)
}
 32a:	40a7853b          	subw	a0,a5,a0
 32e:	60a2                	ld	ra,8(sp)
 330:	6402                	ld	s0,0(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret

0000000000000336 <strlen>:

uint
strlen(const char *s)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 33e:	00054783          	lbu	a5,0(a0)
 342:	cf91                	beqz	a5,35e <strlen+0x28>
 344:	00150793          	addi	a5,a0,1
 348:	86be                	mv	a3,a5
 34a:	0785                	addi	a5,a5,1
 34c:	fff7c703          	lbu	a4,-1(a5)
 350:	ff65                	bnez	a4,348 <strlen+0x12>
 352:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 356:	60a2                	ld	ra,8(sp)
 358:	6402                	ld	s0,0(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret
  for(n = 0; s[n]; n++)
 35e:	4501                	li	a0,0
 360:	bfdd                	j	356 <strlen+0x20>

0000000000000362 <memset>:

void*
memset(void *dst, int c, uint n)
{
 362:	1141                	addi	sp,sp,-16
 364:	e406                	sd	ra,8(sp)
 366:	e022                	sd	s0,0(sp)
 368:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 36a:	ca19                	beqz	a2,380 <memset+0x1e>
 36c:	87aa                	mv	a5,a0
 36e:	1602                	slli	a2,a2,0x20
 370:	9201                	srli	a2,a2,0x20
 372:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 376:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 37a:	0785                	addi	a5,a5,1
 37c:	fee79de3          	bne	a5,a4,376 <memset+0x14>
  }
  return dst;
}
 380:	60a2                	ld	ra,8(sp)
 382:	6402                	ld	s0,0(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret

0000000000000388 <strchr>:

char*
strchr(const char *s, char c)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e406                	sd	ra,8(sp)
 38c:	e022                	sd	s0,0(sp)
 38e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 390:	00054783          	lbu	a5,0(a0)
 394:	cf81                	beqz	a5,3ac <strchr+0x24>
    if(*s == c)
 396:	00f58763          	beq	a1,a5,3a4 <strchr+0x1c>
  for(; *s; s++)
 39a:	0505                	addi	a0,a0,1
 39c:	00054783          	lbu	a5,0(a0)
 3a0:	fbfd                	bnez	a5,396 <strchr+0xe>
      return (char*)s;
  return 0;
 3a2:	4501                	li	a0,0
}
 3a4:	60a2                	ld	ra,8(sp)
 3a6:	6402                	ld	s0,0(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret
  return 0;
 3ac:	4501                	li	a0,0
 3ae:	bfdd                	j	3a4 <strchr+0x1c>

00000000000003b0 <gets>:

char*
gets(char *buf, int max)
{
 3b0:	711d                	addi	sp,sp,-96
 3b2:	ec86                	sd	ra,88(sp)
 3b4:	e8a2                	sd	s0,80(sp)
 3b6:	e4a6                	sd	s1,72(sp)
 3b8:	e0ca                	sd	s2,64(sp)
 3ba:	fc4e                	sd	s3,56(sp)
 3bc:	f852                	sd	s4,48(sp)
 3be:	f456                	sd	s5,40(sp)
 3c0:	f05a                	sd	s6,32(sp)
 3c2:	ec5e                	sd	s7,24(sp)
 3c4:	e862                	sd	s8,16(sp)
 3c6:	1080                	addi	s0,sp,96
 3c8:	8baa                	mv	s7,a0
 3ca:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3cc:	892a                	mv	s2,a0
 3ce:	4481                	li	s1,0
    cc = read(0, &c, 1);
 3d0:	faf40b13          	addi	s6,s0,-81
 3d4:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 3d6:	8c26                	mv	s8,s1
 3d8:	0014899b          	addiw	s3,s1,1
 3dc:	84ce                	mv	s1,s3
 3de:	0349d663          	bge	s3,s4,40a <gets+0x5a>
    cc = read(0, &c, 1);
 3e2:	8656                	mv	a2,s5
 3e4:	85da                	mv	a1,s6
 3e6:	4501                	li	a0,0
 3e8:	00000097          	auipc	ra,0x0
 3ec:	1a4080e7          	jalr	420(ra) # 58c <read>
    if(cc < 1)
 3f0:	00a05d63          	blez	a0,40a <gets+0x5a>
      break;
    buf[i++] = c;
 3f4:	faf44783          	lbu	a5,-81(s0)
 3f8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3fc:	0905                	addi	s2,s2,1
 3fe:	ff678713          	addi	a4,a5,-10
 402:	c319                	beqz	a4,408 <gets+0x58>
 404:	17cd                	addi	a5,a5,-13
 406:	fbe1                	bnez	a5,3d6 <gets+0x26>
    buf[i++] = c;
 408:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 40a:	9c5e                	add	s8,s8,s7
 40c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 410:	855e                	mv	a0,s7
 412:	60e6                	ld	ra,88(sp)
 414:	6446                	ld	s0,80(sp)
 416:	64a6                	ld	s1,72(sp)
 418:	6906                	ld	s2,64(sp)
 41a:	79e2                	ld	s3,56(sp)
 41c:	7a42                	ld	s4,48(sp)
 41e:	7aa2                	ld	s5,40(sp)
 420:	7b02                	ld	s6,32(sp)
 422:	6be2                	ld	s7,24(sp)
 424:	6c42                	ld	s8,16(sp)
 426:	6125                	addi	sp,sp,96
 428:	8082                	ret

000000000000042a <stat>:

int
stat(const char *n, struct stat *st)
{
 42a:	1101                	addi	sp,sp,-32
 42c:	ec06                	sd	ra,24(sp)
 42e:	e822                	sd	s0,16(sp)
 430:	e04a                	sd	s2,0(sp)
 432:	1000                	addi	s0,sp,32
 434:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 436:	4581                	li	a1,0
 438:	00000097          	auipc	ra,0x0
 43c:	17c080e7          	jalr	380(ra) # 5b4 <open>
  if(fd < 0)
 440:	02054663          	bltz	a0,46c <stat+0x42>
 444:	e426                	sd	s1,8(sp)
 446:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 448:	85ca                	mv	a1,s2
 44a:	00000097          	auipc	ra,0x0
 44e:	182080e7          	jalr	386(ra) # 5cc <fstat>
 452:	892a                	mv	s2,a0
  close(fd);
 454:	8526                	mv	a0,s1
 456:	00000097          	auipc	ra,0x0
 45a:	146080e7          	jalr	326(ra) # 59c <close>
  return r;
 45e:	64a2                	ld	s1,8(sp)
}
 460:	854a                	mv	a0,s2
 462:	60e2                	ld	ra,24(sp)
 464:	6442                	ld	s0,16(sp)
 466:	6902                	ld	s2,0(sp)
 468:	6105                	addi	sp,sp,32
 46a:	8082                	ret
    return -1;
 46c:	57fd                	li	a5,-1
 46e:	893e                	mv	s2,a5
 470:	bfc5                	j	460 <stat+0x36>

0000000000000472 <atoi>:

int
atoi(const char *s)
{
 472:	1141                	addi	sp,sp,-16
 474:	e406                	sd	ra,8(sp)
 476:	e022                	sd	s0,0(sp)
 478:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 47a:	00054683          	lbu	a3,0(a0)
 47e:	fd06879b          	addiw	a5,a3,-48
 482:	0ff7f793          	zext.b	a5,a5
 486:	4625                	li	a2,9
 488:	02f66963          	bltu	a2,a5,4ba <atoi+0x48>
 48c:	872a                	mv	a4,a0
  n = 0;
 48e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 490:	0705                	addi	a4,a4,1
 492:	0025179b          	slliw	a5,a0,0x2
 496:	9fa9                	addw	a5,a5,a0
 498:	0017979b          	slliw	a5,a5,0x1
 49c:	9fb5                	addw	a5,a5,a3
 49e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4a2:	00074683          	lbu	a3,0(a4)
 4a6:	fd06879b          	addiw	a5,a3,-48
 4aa:	0ff7f793          	zext.b	a5,a5
 4ae:	fef671e3          	bgeu	a2,a5,490 <atoi+0x1e>
  return n;
}
 4b2:	60a2                	ld	ra,8(sp)
 4b4:	6402                	ld	s0,0(sp)
 4b6:	0141                	addi	sp,sp,16
 4b8:	8082                	ret
  n = 0;
 4ba:	4501                	li	a0,0
 4bc:	bfdd                	j	4b2 <atoi+0x40>

00000000000004be <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4be:	1141                	addi	sp,sp,-16
 4c0:	e406                	sd	ra,8(sp)
 4c2:	e022                	sd	s0,0(sp)
 4c4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4c6:	02b57563          	bgeu	a0,a1,4f0 <memmove+0x32>
    while(n-- > 0)
 4ca:	00c05f63          	blez	a2,4e8 <memmove+0x2a>
 4ce:	1602                	slli	a2,a2,0x20
 4d0:	9201                	srli	a2,a2,0x20
 4d2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4d6:	872a                	mv	a4,a0
      *dst++ = *src++;
 4d8:	0585                	addi	a1,a1,1
 4da:	0705                	addi	a4,a4,1
 4dc:	fff5c683          	lbu	a3,-1(a1)
 4e0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4e4:	fee79ae3          	bne	a5,a4,4d8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4e8:	60a2                	ld	ra,8(sp)
 4ea:	6402                	ld	s0,0(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret
    while(n-- > 0)
 4f0:	fec05ce3          	blez	a2,4e8 <memmove+0x2a>
    dst += n;
 4f4:	00c50733          	add	a4,a0,a2
    src += n;
 4f8:	95b2                	add	a1,a1,a2
 4fa:	fff6079b          	addiw	a5,a2,-1
 4fe:	1782                	slli	a5,a5,0x20
 500:	9381                	srli	a5,a5,0x20
 502:	fff7c793          	not	a5,a5
 506:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 508:	15fd                	addi	a1,a1,-1
 50a:	177d                	addi	a4,a4,-1
 50c:	0005c683          	lbu	a3,0(a1)
 510:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 514:	fef71ae3          	bne	a4,a5,508 <memmove+0x4a>
 518:	bfc1                	j	4e8 <memmove+0x2a>

000000000000051a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 51a:	1141                	addi	sp,sp,-16
 51c:	e406                	sd	ra,8(sp)
 51e:	e022                	sd	s0,0(sp)
 520:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 522:	c61d                	beqz	a2,550 <memcmp+0x36>
 524:	1602                	slli	a2,a2,0x20
 526:	9201                	srli	a2,a2,0x20
 528:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 52c:	00054783          	lbu	a5,0(a0)
 530:	0005c703          	lbu	a4,0(a1)
 534:	00e79863          	bne	a5,a4,544 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 538:	0505                	addi	a0,a0,1
    p2++;
 53a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 53c:	fed518e3          	bne	a0,a3,52c <memcmp+0x12>
  }
  return 0;
 540:	4501                	li	a0,0
 542:	a019                	j	548 <memcmp+0x2e>
      return *p1 - *p2;
 544:	40e7853b          	subw	a0,a5,a4
}
 548:	60a2                	ld	ra,8(sp)
 54a:	6402                	ld	s0,0(sp)
 54c:	0141                	addi	sp,sp,16
 54e:	8082                	ret
  return 0;
 550:	4501                	li	a0,0
 552:	bfdd                	j	548 <memcmp+0x2e>

0000000000000554 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 554:	1141                	addi	sp,sp,-16
 556:	e406                	sd	ra,8(sp)
 558:	e022                	sd	s0,0(sp)
 55a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 55c:	00000097          	auipc	ra,0x0
 560:	f62080e7          	jalr	-158(ra) # 4be <memmove>
}
 564:	60a2                	ld	ra,8(sp)
 566:	6402                	ld	s0,0(sp)
 568:	0141                	addi	sp,sp,16
 56a:	8082                	ret

000000000000056c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 56c:	4885                	li	a7,1
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <exit>:
.global exit
exit:
 li a7, SYS_exit
 574:	4889                	li	a7,2
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <wait>:
.global wait
wait:
 li a7, SYS_wait
 57c:	488d                	li	a7,3
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 584:	4891                	li	a7,4
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <read>:
.global read
read:
 li a7, SYS_read
 58c:	4895                	li	a7,5
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <write>:
.global write
write:
 li a7, SYS_write
 594:	48c1                	li	a7,16
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <close>:
.global close
close:
 li a7, SYS_close
 59c:	48d5                	li	a7,21
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5a4:	4899                	li	a7,6
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <exec>:
.global exec
exec:
 li a7, SYS_exec
 5ac:	489d                	li	a7,7
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <open>:
.global open
open:
 li a7, SYS_open
 5b4:	48bd                	li	a7,15
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5bc:	48c5                	li	a7,17
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5c4:	48c9                	li	a7,18
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5cc:	48a1                	li	a7,8
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <link>:
.global link
link:
 li a7, SYS_link
 5d4:	48cd                	li	a7,19
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5dc:	48d1                	li	a7,20
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5e4:	48a5                	li	a7,9
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <dup>:
.global dup
dup:
 li a7, SYS_dup
 5ec:	48a9                	li	a7,10
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5f4:	48ad                	li	a7,11
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5fc:	48b1                	li	a7,12
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 604:	48b5                	li	a7,13
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 60c:	48b9                	li	a7,14
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 614:	48d9                	li	a7,22
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 61c:	48dd                	li	a7,23
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 624:	48e1                	li	a7,24
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 62c:	48e5                	li	a7,25
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <socket>:
.global socket
socket:
 li a7, SYS_socket
 634:	48e9                	li	a7,26
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <bind>:
.global bind
bind:
 li a7, SYS_bind
 63c:	48ed                	li	a7,27
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <accept>:
.global accept
accept:
 li a7, SYS_accept
 644:	48f5                	li	a7,29
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <listen>:
.global listen
listen:
 li a7, SYS_listen
 64c:	48f1                	li	a7,28
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <connect>:
.global connect
connect:
 li a7, SYS_connect
 654:	48f9                	li	a7,30
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 65c:	1101                	addi	sp,sp,-32
 65e:	ec06                	sd	ra,24(sp)
 660:	e822                	sd	s0,16(sp)
 662:	1000                	addi	s0,sp,32
 664:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 668:	4605                	li	a2,1
 66a:	fef40593          	addi	a1,s0,-17
 66e:	00000097          	auipc	ra,0x0
 672:	f26080e7          	jalr	-218(ra) # 594 <write>
}
 676:	60e2                	ld	ra,24(sp)
 678:	6442                	ld	s0,16(sp)
 67a:	6105                	addi	sp,sp,32
 67c:	8082                	ret

000000000000067e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 67e:	7139                	addi	sp,sp,-64
 680:	fc06                	sd	ra,56(sp)
 682:	f822                	sd	s0,48(sp)
 684:	f04a                	sd	s2,32(sp)
 686:	ec4e                	sd	s3,24(sp)
 688:	0080                	addi	s0,sp,64
 68a:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 68c:	cad9                	beqz	a3,722 <printint+0xa4>
 68e:	01f5d79b          	srliw	a5,a1,0x1f
 692:	cbc1                	beqz	a5,722 <printint+0xa4>
    neg = 1;
    x = -xx;
 694:	40b005bb          	negw	a1,a1
    neg = 1;
 698:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 69a:	fc040993          	addi	s3,s0,-64
  neg = 0;
 69e:	86ce                	mv	a3,s3
  i = 0;
 6a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6a2:	00000817          	auipc	a6,0x0
 6a6:	78e80813          	addi	a6,a6,1934 # e30 <digits>
 6aa:	88ba                	mv	a7,a4
 6ac:	0017051b          	addiw	a0,a4,1
 6b0:	872a                	mv	a4,a0
 6b2:	02c5f7bb          	remuw	a5,a1,a2
 6b6:	1782                	slli	a5,a5,0x20
 6b8:	9381                	srli	a5,a5,0x20
 6ba:	97c2                	add	a5,a5,a6
 6bc:	0007c783          	lbu	a5,0(a5)
 6c0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6c4:	87ae                	mv	a5,a1
 6c6:	02c5d5bb          	divuw	a1,a1,a2
 6ca:	0685                	addi	a3,a3,1
 6cc:	fcc7ffe3          	bgeu	a5,a2,6aa <printint+0x2c>
  if(neg)
 6d0:	00030c63          	beqz	t1,6e8 <printint+0x6a>
    buf[i++] = '-';
 6d4:	fd050793          	addi	a5,a0,-48
 6d8:	00878533          	add	a0,a5,s0
 6dc:	02d00793          	li	a5,45
 6e0:	fef50823          	sb	a5,-16(a0)
 6e4:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 6e8:	02e05763          	blez	a4,716 <printint+0x98>
 6ec:	f426                	sd	s1,40(sp)
 6ee:	377d                	addiw	a4,a4,-1
 6f0:	00e984b3          	add	s1,s3,a4
 6f4:	19fd                	addi	s3,s3,-1
 6f6:	99ba                	add	s3,s3,a4
 6f8:	1702                	slli	a4,a4,0x20
 6fa:	9301                	srli	a4,a4,0x20
 6fc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 700:	0004c583          	lbu	a1,0(s1)
 704:	854a                	mv	a0,s2
 706:	00000097          	auipc	ra,0x0
 70a:	f56080e7          	jalr	-170(ra) # 65c <putc>
  while(--i >= 0)
 70e:	14fd                	addi	s1,s1,-1
 710:	ff3498e3          	bne	s1,s3,700 <printint+0x82>
 714:	74a2                	ld	s1,40(sp)
}
 716:	70e2                	ld	ra,56(sp)
 718:	7442                	ld	s0,48(sp)
 71a:	7902                	ld	s2,32(sp)
 71c:	69e2                	ld	s3,24(sp)
 71e:	6121                	addi	sp,sp,64
 720:	8082                	ret
  neg = 0;
 722:	4301                	li	t1,0
 724:	bf9d                	j	69a <printint+0x1c>

0000000000000726 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 726:	715d                	addi	sp,sp,-80
 728:	e486                	sd	ra,72(sp)
 72a:	e0a2                	sd	s0,64(sp)
 72c:	f84a                	sd	s2,48(sp)
 72e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 730:	0005c903          	lbu	s2,0(a1)
 734:	1a090b63          	beqz	s2,8ea <vprintf+0x1c4>
 738:	fc26                	sd	s1,56(sp)
 73a:	f44e                	sd	s3,40(sp)
 73c:	f052                	sd	s4,32(sp)
 73e:	ec56                	sd	s5,24(sp)
 740:	e85a                	sd	s6,16(sp)
 742:	e45e                	sd	s7,8(sp)
 744:	8aaa                	mv	s5,a0
 746:	8bb2                	mv	s7,a2
 748:	00158493          	addi	s1,a1,1
  state = 0;
 74c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 74e:	02500a13          	li	s4,37
 752:	4b55                	li	s6,21
 754:	a839                	j	772 <vprintf+0x4c>
        putc(fd, c);
 756:	85ca                	mv	a1,s2
 758:	8556                	mv	a0,s5
 75a:	00000097          	auipc	ra,0x0
 75e:	f02080e7          	jalr	-254(ra) # 65c <putc>
 762:	a019                	j	768 <vprintf+0x42>
    } else if(state == '%'){
 764:	01498d63          	beq	s3,s4,77e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 768:	0485                	addi	s1,s1,1
 76a:	fff4c903          	lbu	s2,-1(s1)
 76e:	16090863          	beqz	s2,8de <vprintf+0x1b8>
    if(state == 0){
 772:	fe0999e3          	bnez	s3,764 <vprintf+0x3e>
      if(c == '%'){
 776:	ff4910e3          	bne	s2,s4,756 <vprintf+0x30>
        state = '%';
 77a:	89d2                	mv	s3,s4
 77c:	b7f5                	j	768 <vprintf+0x42>
      if(c == 'd'){
 77e:	13490563          	beq	s2,s4,8a8 <vprintf+0x182>
 782:	f9d9079b          	addiw	a5,s2,-99
 786:	0ff7f793          	zext.b	a5,a5
 78a:	12fb6863          	bltu	s6,a5,8ba <vprintf+0x194>
 78e:	f9d9079b          	addiw	a5,s2,-99
 792:	0ff7f713          	zext.b	a4,a5
 796:	12eb6263          	bltu	s6,a4,8ba <vprintf+0x194>
 79a:	00271793          	slli	a5,a4,0x2
 79e:	00000717          	auipc	a4,0x0
 7a2:	63a70713          	addi	a4,a4,1594 # dd8 <ithread_join+0xf8>
 7a6:	97ba                	add	a5,a5,a4
 7a8:	439c                	lw	a5,0(a5)
 7aa:	97ba                	add	a5,a5,a4
 7ac:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7ae:	008b8913          	addi	s2,s7,8
 7b2:	4685                	li	a3,1
 7b4:	4629                	li	a2,10
 7b6:	000ba583          	lw	a1,0(s7)
 7ba:	8556                	mv	a0,s5
 7bc:	00000097          	auipc	ra,0x0
 7c0:	ec2080e7          	jalr	-318(ra) # 67e <printint>
 7c4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7c6:	4981                	li	s3,0
 7c8:	b745                	j	768 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ca:	008b8913          	addi	s2,s7,8
 7ce:	4681                	li	a3,0
 7d0:	4629                	li	a2,10
 7d2:	000ba583          	lw	a1,0(s7)
 7d6:	8556                	mv	a0,s5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	ea6080e7          	jalr	-346(ra) # 67e <printint>
 7e0:	8bca                	mv	s7,s2
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	b751                	j	768 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7e6:	008b8913          	addi	s2,s7,8
 7ea:	4681                	li	a3,0
 7ec:	4641                	li	a2,16
 7ee:	000ba583          	lw	a1,0(s7)
 7f2:	8556                	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	e8a080e7          	jalr	-374(ra) # 67e <printint>
 7fc:	8bca                	mv	s7,s2
      state = 0;
 7fe:	4981                	li	s3,0
 800:	b7a5                	j	768 <vprintf+0x42>
 802:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 804:	008b8793          	addi	a5,s7,8
 808:	8c3e                	mv	s8,a5
 80a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 80e:	03000593          	li	a1,48
 812:	8556                	mv	a0,s5
 814:	00000097          	auipc	ra,0x0
 818:	e48080e7          	jalr	-440(ra) # 65c <putc>
  putc(fd, 'x');
 81c:	07800593          	li	a1,120
 820:	8556                	mv	a0,s5
 822:	00000097          	auipc	ra,0x0
 826:	e3a080e7          	jalr	-454(ra) # 65c <putc>
 82a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 82c:	00000b97          	auipc	s7,0x0
 830:	604b8b93          	addi	s7,s7,1540 # e30 <digits>
 834:	03c9d793          	srli	a5,s3,0x3c
 838:	97de                	add	a5,a5,s7
 83a:	0007c583          	lbu	a1,0(a5)
 83e:	8556                	mv	a0,s5
 840:	00000097          	auipc	ra,0x0
 844:	e1c080e7          	jalr	-484(ra) # 65c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 848:	0992                	slli	s3,s3,0x4
 84a:	397d                	addiw	s2,s2,-1
 84c:	fe0914e3          	bnez	s2,834 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 850:	8be2                	mv	s7,s8
      state = 0;
 852:	4981                	li	s3,0
 854:	6c02                	ld	s8,0(sp)
 856:	bf09                	j	768 <vprintf+0x42>
        s = va_arg(ap, char*);
 858:	008b8993          	addi	s3,s7,8
 85c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 860:	02090163          	beqz	s2,882 <vprintf+0x15c>
        while(*s != 0){
 864:	00094583          	lbu	a1,0(s2)
 868:	c9a5                	beqz	a1,8d8 <vprintf+0x1b2>
          putc(fd, *s);
 86a:	8556                	mv	a0,s5
 86c:	00000097          	auipc	ra,0x0
 870:	df0080e7          	jalr	-528(ra) # 65c <putc>
          s++;
 874:	0905                	addi	s2,s2,1
        while(*s != 0){
 876:	00094583          	lbu	a1,0(s2)
 87a:	f9e5                	bnez	a1,86a <vprintf+0x144>
        s = va_arg(ap, char*);
 87c:	8bce                	mv	s7,s3
      state = 0;
 87e:	4981                	li	s3,0
 880:	b5e5                	j	768 <vprintf+0x42>
          s = "(null)";
 882:	00000917          	auipc	s2,0x0
 886:	51e90913          	addi	s2,s2,1310 # da0 <ithread_join+0xc0>
        while(*s != 0){
 88a:	02800593          	li	a1,40
 88e:	bff1                	j	86a <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 890:	008b8913          	addi	s2,s7,8
 894:	000bc583          	lbu	a1,0(s7)
 898:	8556                	mv	a0,s5
 89a:	00000097          	auipc	ra,0x0
 89e:	dc2080e7          	jalr	-574(ra) # 65c <putc>
 8a2:	8bca                	mv	s7,s2
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	b5c9                	j	768 <vprintf+0x42>
        putc(fd, c);
 8a8:	02500593          	li	a1,37
 8ac:	8556                	mv	a0,s5
 8ae:	00000097          	auipc	ra,0x0
 8b2:	dae080e7          	jalr	-594(ra) # 65c <putc>
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	bd45                	j	768 <vprintf+0x42>
        putc(fd, '%');
 8ba:	02500593          	li	a1,37
 8be:	8556                	mv	a0,s5
 8c0:	00000097          	auipc	ra,0x0
 8c4:	d9c080e7          	jalr	-612(ra) # 65c <putc>
        putc(fd, c);
 8c8:	85ca                	mv	a1,s2
 8ca:	8556                	mv	a0,s5
 8cc:	00000097          	auipc	ra,0x0
 8d0:	d90080e7          	jalr	-624(ra) # 65c <putc>
      state = 0;
 8d4:	4981                	li	s3,0
 8d6:	bd49                	j	768 <vprintf+0x42>
        s = va_arg(ap, char*);
 8d8:	8bce                	mv	s7,s3
      state = 0;
 8da:	4981                	li	s3,0
 8dc:	b571                	j	768 <vprintf+0x42>
 8de:	74e2                	ld	s1,56(sp)
 8e0:	79a2                	ld	s3,40(sp)
 8e2:	7a02                	ld	s4,32(sp)
 8e4:	6ae2                	ld	s5,24(sp)
 8e6:	6b42                	ld	s6,16(sp)
 8e8:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8ea:	60a6                	ld	ra,72(sp)
 8ec:	6406                	ld	s0,64(sp)
 8ee:	7942                	ld	s2,48(sp)
 8f0:	6161                	addi	sp,sp,80
 8f2:	8082                	ret

00000000000008f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f4:	715d                	addi	sp,sp,-80
 8f6:	ec06                	sd	ra,24(sp)
 8f8:	e822                	sd	s0,16(sp)
 8fa:	1000                	addi	s0,sp,32
 8fc:	e010                	sd	a2,0(s0)
 8fe:	e414                	sd	a3,8(s0)
 900:	e818                	sd	a4,16(s0)
 902:	ec1c                	sd	a5,24(s0)
 904:	03043023          	sd	a6,32(s0)
 908:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 90c:	8622                	mv	a2,s0
 90e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 912:	00000097          	auipc	ra,0x0
 916:	e14080e7          	jalr	-492(ra) # 726 <vprintf>
}
 91a:	60e2                	ld	ra,24(sp)
 91c:	6442                	ld	s0,16(sp)
 91e:	6161                	addi	sp,sp,80
 920:	8082                	ret

0000000000000922 <printf>:

void
printf(const char *fmt, ...)
{
 922:	711d                	addi	sp,sp,-96
 924:	ec06                	sd	ra,24(sp)
 926:	e822                	sd	s0,16(sp)
 928:	1000                	addi	s0,sp,32
 92a:	e40c                	sd	a1,8(s0)
 92c:	e810                	sd	a2,16(s0)
 92e:	ec14                	sd	a3,24(s0)
 930:	f018                	sd	a4,32(s0)
 932:	f41c                	sd	a5,40(s0)
 934:	03043823          	sd	a6,48(s0)
 938:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 93c:	00840613          	addi	a2,s0,8
 940:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 944:	85aa                	mv	a1,a0
 946:	4505                	li	a0,1
 948:	00000097          	auipc	ra,0x0
 94c:	dde080e7          	jalr	-546(ra) # 726 <vprintf>
}
 950:	60e2                	ld	ra,24(sp)
 952:	6442                	ld	s0,16(sp)
 954:	6125                	addi	sp,sp,96
 956:	8082                	ret

0000000000000958 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 958:	1141                	addi	sp,sp,-16
 95a:	e406                	sd	ra,8(sp)
 95c:	e022                	sd	s0,0(sp)
 95e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 960:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 964:	00001797          	auipc	a5,0x1
 968:	c2c7b783          	ld	a5,-980(a5) # 1590 <freep>
 96c:	a039                	j	97a <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 96e:	6398                	ld	a4,0(a5)
 970:	00e7e463          	bltu	a5,a4,978 <free+0x20>
 974:	00e6ea63          	bltu	a3,a4,988 <free+0x30>
{
 978:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 97a:	fed7fae3          	bgeu	a5,a3,96e <free+0x16>
 97e:	6398                	ld	a4,0(a5)
 980:	00e6e463          	bltu	a3,a4,988 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 984:	fee7eae3          	bltu	a5,a4,978 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 988:	ff852583          	lw	a1,-8(a0)
 98c:	6390                	ld	a2,0(a5)
 98e:	02059813          	slli	a6,a1,0x20
 992:	01c85713          	srli	a4,a6,0x1c
 996:	9736                	add	a4,a4,a3
 998:	02e60563          	beq	a2,a4,9c2 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 99c:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 9a0:	4790                	lw	a2,8(a5)
 9a2:	02061593          	slli	a1,a2,0x20
 9a6:	01c5d713          	srli	a4,a1,0x1c
 9aa:	973e                	add	a4,a4,a5
 9ac:	02e68263          	beq	a3,a4,9d0 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9b0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9b2:	00001717          	auipc	a4,0x1
 9b6:	bcf73f23          	sd	a5,-1058(a4) # 1590 <freep>
}
 9ba:	60a2                	ld	ra,8(sp)
 9bc:	6402                	ld	s0,0(sp)
 9be:	0141                	addi	sp,sp,16
 9c0:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 9c2:	4618                	lw	a4,8(a2)
 9c4:	9f2d                	addw	a4,a4,a1
 9c6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9ca:	6398                	ld	a4,0(a5)
 9cc:	6310                	ld	a2,0(a4)
 9ce:	b7f9                	j	99c <free+0x44>
    p->s.size += bp->s.size;
 9d0:	ff852703          	lw	a4,-8(a0)
 9d4:	9f31                	addw	a4,a4,a2
 9d6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9d8:	ff053683          	ld	a3,-16(a0)
 9dc:	bfd1                	j	9b0 <free+0x58>

00000000000009de <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9de:	7139                	addi	sp,sp,-64
 9e0:	fc06                	sd	ra,56(sp)
 9e2:	f822                	sd	s0,48(sp)
 9e4:	f04a                	sd	s2,32(sp)
 9e6:	ec4e                	sd	s3,24(sp)
 9e8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ea:	02051993          	slli	s3,a0,0x20
 9ee:	0209d993          	srli	s3,s3,0x20
 9f2:	09bd                	addi	s3,s3,15
 9f4:	0049d993          	srli	s3,s3,0x4
 9f8:	2985                	addiw	s3,s3,1
 9fa:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9fc:	00001517          	auipc	a0,0x1
 a00:	b9453503          	ld	a0,-1132(a0) # 1590 <freep>
 a04:	c905                	beqz	a0,a34 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a06:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a08:	4798                	lw	a4,8(a5)
 a0a:	09377a63          	bgeu	a4,s3,a9e <malloc+0xc0>
 a0e:	f426                	sd	s1,40(sp)
 a10:	e852                	sd	s4,16(sp)
 a12:	e456                	sd	s5,8(sp)
 a14:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a16:	8a4e                	mv	s4,s3
 a18:	6705                	lui	a4,0x1
 a1a:	00e9f363          	bgeu	s3,a4,a20 <malloc+0x42>
 a1e:	6a05                	lui	s4,0x1
 a20:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a24:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a28:	00001497          	auipc	s1,0x1
 a2c:	b6848493          	addi	s1,s1,-1176 # 1590 <freep>
  if(p == (char*)-1)
 a30:	5afd                	li	s5,-1
 a32:	a089                	j	a74 <malloc+0x96>
 a34:	f426                	sd	s1,40(sp)
 a36:	e852                	sd	s4,16(sp)
 a38:	e456                	sd	s5,8(sp)
 a3a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a3c:	00001797          	auipc	a5,0x1
 a40:	b8478793          	addi	a5,a5,-1148 # 15c0 <base>
 a44:	00001717          	auipc	a4,0x1
 a48:	b4f73623          	sd	a5,-1204(a4) # 1590 <freep>
 a4c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a4e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a52:	b7d1                	j	a16 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a54:	6398                	ld	a4,0(a5)
 a56:	e118                	sd	a4,0(a0)
 a58:	a8b9                	j	ab6 <malloc+0xd8>
  hp->s.size = nu;
 a5a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a5e:	0541                	addi	a0,a0,16
 a60:	00000097          	auipc	ra,0x0
 a64:	ef8080e7          	jalr	-264(ra) # 958 <free>
  return freep;
 a68:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a6a:	c135                	beqz	a0,ace <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a6c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a6e:	4798                	lw	a4,8(a5)
 a70:	03277363          	bgeu	a4,s2,a96 <malloc+0xb8>
    if(p == freep)
 a74:	6098                	ld	a4,0(s1)
 a76:	853e                	mv	a0,a5
 a78:	fef71ae3          	bne	a4,a5,a6c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a7c:	8552                	mv	a0,s4
 a7e:	00000097          	auipc	ra,0x0
 a82:	b7e080e7          	jalr	-1154(ra) # 5fc <sbrk>
  if(p == (char*)-1)
 a86:	fd551ae3          	bne	a0,s5,a5a <malloc+0x7c>
        return 0;
 a8a:	4501                	li	a0,0
 a8c:	74a2                	ld	s1,40(sp)
 a8e:	6a42                	ld	s4,16(sp)
 a90:	6aa2                	ld	s5,8(sp)
 a92:	6b02                	ld	s6,0(sp)
 a94:	a03d                	j	ac2 <malloc+0xe4>
 a96:	74a2                	ld	s1,40(sp)
 a98:	6a42                	ld	s4,16(sp)
 a9a:	6aa2                	ld	s5,8(sp)
 a9c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a9e:	fae90be3          	beq	s2,a4,a54 <malloc+0x76>
        p->s.size -= nunits;
 aa2:	4137073b          	subw	a4,a4,s3
 aa6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aa8:	02071693          	slli	a3,a4,0x20
 aac:	01c6d713          	srli	a4,a3,0x1c
 ab0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ab2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ab6:	00001717          	auipc	a4,0x1
 aba:	aca73d23          	sd	a0,-1318(a4) # 1590 <freep>
      return (void*)(p + 1);
 abe:	01078513          	addi	a0,a5,16
  }
}
 ac2:	70e2                	ld	ra,56(sp)
 ac4:	7442                	ld	s0,48(sp)
 ac6:	7902                	ld	s2,32(sp)
 ac8:	69e2                	ld	s3,24(sp)
 aca:	6121                	addi	sp,sp,64
 acc:	8082                	ret
 ace:	74a2                	ld	s1,40(sp)
 ad0:	6a42                	ld	s4,16(sp)
 ad2:	6aa2                	ld	s5,8(sp)
 ad4:	6b02                	ld	s6,0(sp)
 ad6:	b7f5                	j	ac2 <malloc+0xe4>

0000000000000ad8 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 ad8:	1141                	addi	sp,sp,-16
 ada:	e406                	sd	ra,8(sp)
 adc:	e022                	sd	s0,0(sp)
 ade:	0800                	addi	s0,sp,16
  thread_exit(status);
 ae0:	2501                	sext.w	a0,a0
 ae2:	00000097          	auipc	ra,0x0
 ae6:	b4a080e7          	jalr	-1206(ra) # 62c <thread_exit>
}
 aea:	60a2                	ld	ra,8(sp)
 aec:	6402                	ld	s0,0(sp)
 aee:	0141                	addi	sp,sp,16
 af0:	8082                	ret

0000000000000af2 <free_stacks>:
int free_stacks() {
 af2:	7179                	addi	sp,sp,-48
 af4:	f406                	sd	ra,40(sp)
 af6:	f022                	sd	s0,32(sp)
 af8:	ec26                	sd	s1,24(sp)
 afa:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 afc:	00001797          	auipc	a5,0x1
 b00:	aa47a783          	lw	a5,-1372(a5) # 15a0 <num_threads>
 b04:	04f05063          	blez	a5,b44 <free_stacks+0x52>
 b08:	e84a                	sd	s2,16(sp)
 b0a:	e44e                	sd	s3,8(sp)
 b0c:	4481                	li	s1,0
    free(stacks[i]);
 b0e:	00001997          	auipc	s3,0x1
 b12:	a8a98993          	addi	s3,s3,-1398 # 1598 <stacks>
  for (int i = 0; i < num_threads; i++) {
 b16:	00001917          	auipc	s2,0x1
 b1a:	a8a90913          	addi	s2,s2,-1398 # 15a0 <num_threads>
    free(stacks[i]);
 b1e:	0009b783          	ld	a5,0(s3)
 b22:	00349713          	slli	a4,s1,0x3
 b26:	97ba                	add	a5,a5,a4
 b28:	6388                	ld	a0,0(a5)
 b2a:	00000097          	auipc	ra,0x0
 b2e:	e2e080e7          	jalr	-466(ra) # 958 <free>
  for (int i = 0; i < num_threads; i++) {
 b32:	0485                	addi	s1,s1,1
 b34:	00092703          	lw	a4,0(s2)
 b38:	0004879b          	sext.w	a5,s1
 b3c:	fee7c1e3          	blt	a5,a4,b1e <free_stacks+0x2c>
 b40:	6942                	ld	s2,16(sp)
 b42:	69a2                	ld	s3,8(sp)
  free(stacks);
 b44:	00001497          	auipc	s1,0x1
 b48:	a5448493          	addi	s1,s1,-1452 # 1598 <stacks>
 b4c:	6088                	ld	a0,0(s1)
 b4e:	00000097          	auipc	ra,0x0
 b52:	e0a080e7          	jalr	-502(ra) # 958 <free>
  stacks = 0;
 b56:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 b5a:	00001797          	auipc	a5,0x1
 b5e:	a407a323          	sw	zero,-1466(a5) # 15a0 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 b62:	47a1                	li	a5,8
 b64:	00001717          	auipc	a4,0x1
 b68:	a0f72e23          	sw	a5,-1508(a4) # 1580 <max_stacks>
  threads_done = 0;
 b6c:	00001797          	auipc	a5,0x1
 b70:	a207ac23          	sw	zero,-1480(a5) # 15a4 <threads_done>
}
 b74:	4501                	li	a0,0
 b76:	70a2                	ld	ra,40(sp)
 b78:	7402                	ld	s0,32(sp)
 b7a:	64e2                	ld	s1,24(sp)
 b7c:	6145                	addi	sp,sp,48
 b7e:	8082                	ret

0000000000000b80 <expand_num_threads>:
int expand_num_threads() {
 b80:	1101                	addi	sp,sp,-32
 b82:	ec06                	sd	ra,24(sp)
 b84:	e822                	sd	s0,16(sp)
 b86:	e426                	sd	s1,8(sp)
 b88:	e04a                	sd	s2,0(sp)
 b8a:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 b8c:	00001797          	auipc	a5,0x1
 b90:	9f478793          	addi	a5,a5,-1548 # 1580 <max_stacks>
 b94:	4388                	lw	a0,0(a5)
 b96:	0015151b          	slliw	a0,a0,0x1
 b9a:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 b9c:	0035151b          	slliw	a0,a0,0x3
 ba0:	00000097          	auipc	ra,0x0
 ba4:	e3e080e7          	jalr	-450(ra) # 9de <malloc>
 ba8:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 baa:	00001617          	auipc	a2,0x1
 bae:	9f662603          	lw	a2,-1546(a2) # 15a0 <num_threads>
 bb2:	00001497          	auipc	s1,0x1
 bb6:	9e648493          	addi	s1,s1,-1562 # 1598 <stacks>
 bba:	0036161b          	slliw	a2,a2,0x3
 bbe:	608c                	ld	a1,0(s1)
 bc0:	00000097          	auipc	ra,0x0
 bc4:	8fe080e7          	jalr	-1794(ra) # 4be <memmove>
  free(stacks);
 bc8:	6088                	ld	a0,0(s1)
 bca:	00000097          	auipc	ra,0x0
 bce:	d8e080e7          	jalr	-626(ra) # 958 <free>
  stacks = new_stacks;
 bd2:	0124b023          	sd	s2,0(s1)
}
 bd6:	4501                	li	a0,0
 bd8:	60e2                	ld	ra,24(sp)
 bda:	6442                	ld	s0,16(sp)
 bdc:	64a2                	ld	s1,8(sp)
 bde:	6902                	ld	s2,0(sp)
 be0:	6105                	addi	sp,sp,32
 be2:	8082                	ret

0000000000000be4 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 be4:	7179                	addi	sp,sp,-48
 be6:	f406                	sd	ra,40(sp)
 be8:	f022                	sd	s0,32(sp)
 bea:	e84a                	sd	s2,16(sp)
 bec:	e44e                	sd	s3,8(sp)
 bee:	1800                	addi	s0,sp,48
 bf0:	892a                	mv	s2,a0
 bf2:	89ae                	mv	s3,a1
  if (stacks == 0) {
 bf4:	00001797          	auipc	a5,0x1
 bf8:	9a47b783          	ld	a5,-1628(a5) # 1598 <stacks>
 bfc:	c3d9                	beqz	a5,c82 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 bfe:	00001797          	auipc	a5,0x1
 c02:	9827a783          	lw	a5,-1662(a5) # 1580 <max_stacks>
 c06:	00001717          	auipc	a4,0x1
 c0a:	99a72703          	lw	a4,-1638(a4) # 15a0 <num_threads>
 c0e:	0af71463          	bne	a4,a5,cb6 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 c12:	04000713          	li	a4,64
 c16:	08e78563          	beq	a5,a4,ca0 <ithread_create+0xbc>
 c1a:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 c1c:	00000097          	auipc	ra,0x0
 c20:	f64080e7          	jalr	-156(ra) # b80 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 c24:	6505                	lui	a0,0x1
 c26:	00000097          	auipc	ra,0x0
 c2a:	db8080e7          	jalr	-584(ra) # 9de <malloc>
 c2e:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 c30:	00001717          	auipc	a4,0x1
 c34:	97072703          	lw	a4,-1680(a4) # 15a0 <num_threads>
 c38:	070e                	slli	a4,a4,0x3
 c3a:	00001797          	auipc	a5,0x1
 c3e:	95e7b783          	ld	a5,-1698(a5) # 1598 <stacks>
 c42:	97ba                	add	a5,a5,a4
 c44:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 c46:	00000697          	auipc	a3,0x0
 c4a:	e9268693          	addi	a3,a3,-366 # ad8 <ithread_exit>
 c4e:	862a                	mv	a2,a0
 c50:	85ce                	mv	a1,s3
 c52:	854a                	mv	a0,s2
 c54:	00000097          	auipc	ra,0x0
 c58:	9c8080e7          	jalr	-1592(ra) # 61c <create_thread>
 c5c:	892a                	mv	s2,a0
  if (res != -1) {
 c5e:	57fd                	li	a5,-1
 c60:	04f50d63          	beq	a0,a5,cba <ithread_create+0xd6>
    num_threads++;
 c64:	00001717          	auipc	a4,0x1
 c68:	93c70713          	addi	a4,a4,-1732 # 15a0 <num_threads>
 c6c:	431c                	lw	a5,0(a4)
 c6e:	2785                	addiw	a5,a5,1
 c70:	c31c                	sw	a5,0(a4)
 c72:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 c74:	854a                	mv	a0,s2
 c76:	70a2                	ld	ra,40(sp)
 c78:	7402                	ld	s0,32(sp)
 c7a:	6942                	ld	s2,16(sp)
 c7c:	69a2                	ld	s3,8(sp)
 c7e:	6145                	addi	sp,sp,48
 c80:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 c82:	00001517          	auipc	a0,0x1
 c86:	8fe52503          	lw	a0,-1794(a0) # 1580 <max_stacks>
 c8a:	0035151b          	slliw	a0,a0,0x3
 c8e:	00000097          	auipc	ra,0x0
 c92:	d50080e7          	jalr	-688(ra) # 9de <malloc>
 c96:	00001797          	auipc	a5,0x1
 c9a:	90a7b123          	sd	a0,-1790(a5) # 1598 <stacks>
 c9e:	b785                	j	bfe <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 ca0:	00000517          	auipc	a0,0x0
 ca4:	10850513          	addi	a0,a0,264 # da8 <ithread_join+0xc8>
 ca8:	00000097          	auipc	ra,0x0
 cac:	c7a080e7          	jalr	-902(ra) # 922 <printf>
      return -1;
 cb0:	57fd                	li	a5,-1
 cb2:	893e                	mv	s2,a5
 cb4:	b7c1                	j	c74 <ithread_create+0x90>
 cb6:	ec26                	sd	s1,24(sp)
 cb8:	b7b5                	j	c24 <ithread_create+0x40>
    free(stack_ptr);
 cba:	8526                	mv	a0,s1
 cbc:	00000097          	auipc	ra,0x0
 cc0:	c9c080e7          	jalr	-868(ra) # 958 <free>
    stacks[num_threads] = 0;
 cc4:	00001717          	auipc	a4,0x1
 cc8:	8dc72703          	lw	a4,-1828(a4) # 15a0 <num_threads>
 ccc:	070e                	slli	a4,a4,0x3
 cce:	00001797          	auipc	a5,0x1
 cd2:	8ca7b783          	ld	a5,-1846(a5) # 1598 <stacks>
 cd6:	97ba                	add	a5,a5,a4
 cd8:	0007b023          	sd	zero,0(a5)
 cdc:	64e2                	ld	s1,24(sp)
 cde:	bf59                	j	c74 <ithread_create+0x90>

0000000000000ce0 <ithread_join>:

int ithread_join(int thread_id) {
 ce0:	1101                	addi	sp,sp,-32
 ce2:	ec06                	sd	ra,24(sp)
 ce4:	e822                	sd	s0,16(sp)
 ce6:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 ce8:	ff040793          	addi	a5,s0,-16
 cec:	ffc7859b          	addiw	a1,a5,-4
 cf0:	00000097          	auipc	ra,0x0
 cf4:	934080e7          	jalr	-1740(ra) # 624 <join_thread>
  threads_done++;
 cf8:	00001717          	auipc	a4,0x1
 cfc:	8ac70713          	addi	a4,a4,-1876 # 15a4 <threads_done>
 d00:	431c                	lw	a5,0(a4)
 d02:	2785                	addiw	a5,a5,1
 d04:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 d06:	00001717          	auipc	a4,0x1
 d0a:	89a72703          	lw	a4,-1894(a4) # 15a0 <num_threads>
 d0e:	00f70863          	beq	a4,a5,d1e <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 d12:	fec42503          	lw	a0,-20(s0)
 d16:	60e2                	ld	ra,24(sp)
 d18:	6442                	ld	s0,16(sp)
 d1a:	6105                	addi	sp,sp,32
 d1c:	8082                	ret
    free_stacks();
 d1e:	00000097          	auipc	ra,0x0
 d22:	dd4080e7          	jalr	-556(ra) # af2 <free_stacks>
 d26:	b7f5                	j	d12 <ithread_join+0x32>
