
src/user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	332080e7          	jalr	818(ra) # 33e <strlen>
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
  3c:	306080e7          	jalr	774(ra) # 33e <strlen>
  40:	2501                	sext.w	a0,a0
  42:	47b5                	li	a5,13
  44:	00a7f863          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  48:	8526                	mv	a0,s1
  4a:	70a2                	ld	ra,40(sp)
  4c:	7402                	ld	s0,32(sp)
  4e:	64e2                	ld	s1,24(sp)
  50:	6145                	addi	sp,sp,48
  52:	8082                	ret
  54:	e84a                	sd	s2,16(sp)
  56:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  58:	8526                	mv	a0,s1
  5a:	00000097          	auipc	ra,0x0
  5e:	2e4080e7          	jalr	740(ra) # 33e <strlen>
  62:	00001997          	auipc	s3,0x1
  66:	fce98993          	addi	s3,s3,-50 # 1030 <buf.0>
  6a:	0005061b          	sext.w	a2,a0
  6e:	85a6                	mv	a1,s1
  70:	854e                	mv	a0,s3
  72:	00000097          	auipc	ra,0x0
  76:	4b2080e7          	jalr	1202(ra) # 524 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7a:	8526                	mv	a0,s1
  7c:	00000097          	auipc	ra,0x0
  80:	2c2080e7          	jalr	706(ra) # 33e <strlen>
  84:	0005091b          	sext.w	s2,a0
  88:	8526                	mv	a0,s1
  8a:	00000097          	auipc	ra,0x0
  8e:	2b4080e7          	jalr	692(ra) # 33e <strlen>
  92:	1902                	slli	s2,s2,0x20
  94:	02095913          	srli	s2,s2,0x20
  98:	4639                	li	a2,14
  9a:	9e09                	subw	a2,a2,a0
  9c:	02000593          	li	a1,32
  a0:	01298533          	add	a0,s3,s2
  a4:	00000097          	auipc	ra,0x0
  a8:	2c4080e7          	jalr	708(ra) # 368 <memset>
  return buf;
  ac:	84ce                	mv	s1,s3
  ae:	6942                	ld	s2,16(sp)
  b0:	69a2                	ld	s3,8(sp)
  b2:	bf59                	j	48 <fmtname+0x48>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	25213823          	sd	s2,592(sp)
  c4:	1c80                	addi	s0,sp,624
  c6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  c8:	4581                	li	a1,0
  ca:	00000097          	auipc	ra,0x0
  ce:	5e4080e7          	jalr	1508(ra) # 6ae <open>
  d2:	06054b63          	bltz	a0,148 <ls+0x94>
  d6:	24913c23          	sd	s1,600(sp)
  da:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  dc:	d9840593          	addi	a1,s0,-616
  e0:	00000097          	auipc	ra,0x0
  e4:	5e6080e7          	jalr	1510(ra) # 6c6 <fstat>
  e8:	06054b63          	bltz	a0,15e <ls+0xaa>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  ec:	da041783          	lh	a5,-608(s0)
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
 10c:	da843703          	ld	a4,-600(s0)
 110:	d9c42683          	lw	a3,-612(s0)
 114:	da041603          	lh	a2,-608(s0)
 118:	00001517          	auipc	a0,0x1
 11c:	d6850513          	addi	a0,a0,-664 # e80 <ithread_join+0x7e>
 120:	00001097          	auipc	ra,0x1
 124:	924080e7          	jalr	-1756(ra) # a44 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 128:	8526                	mv	a0,s1
 12a:	00000097          	auipc	ra,0x0
 12e:	56c080e7          	jalr	1388(ra) # 696 <close>
 132:	25813483          	ld	s1,600(sp)
}
 136:	26813083          	ld	ra,616(sp)
 13a:	26013403          	ld	s0,608(sp)
 13e:	25013903          	ld	s2,592(sp)
 142:	27010113          	addi	sp,sp,624
 146:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 148:	864a                	mv	a2,s2
 14a:	00001597          	auipc	a1,0x1
 14e:	d0658593          	addi	a1,a1,-762 # e50 <ithread_join+0x4e>
 152:	4509                	li	a0,2
 154:	00001097          	auipc	ra,0x1
 158:	8c2080e7          	jalr	-1854(ra) # a16 <fprintf>
    return;
 15c:	bfe9                	j	136 <ls+0x82>
    fprintf(2, "ls: cannot stat %s\n", path);
 15e:	864a                	mv	a2,s2
 160:	00001597          	auipc	a1,0x1
 164:	d0858593          	addi	a1,a1,-760 # e68 <ithread_join+0x66>
 168:	4509                	li	a0,2
 16a:	00001097          	auipc	ra,0x1
 16e:	8ac080e7          	jalr	-1876(ra) # a16 <fprintf>
    close(fd);
 172:	8526                	mv	a0,s1
 174:	00000097          	auipc	ra,0x0
 178:	522080e7          	jalr	1314(ra) # 696 <close>
    return;
 17c:	25813483          	ld	s1,600(sp)
 180:	bf5d                	j	136 <ls+0x82>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 182:	854a                	mv	a0,s2
 184:	00000097          	auipc	ra,0x0
 188:	1ba080e7          	jalr	442(ra) # 33e <strlen>
 18c:	2541                	addiw	a0,a0,16
 18e:	20000793          	li	a5,512
 192:	00a7fb63          	bgeu	a5,a0,1a8 <ls+0xf4>
      printf("ls: path too long\n");
 196:	00001517          	auipc	a0,0x1
 19a:	cfa50513          	addi	a0,a0,-774 # e90 <ithread_join+0x8e>
 19e:	00001097          	auipc	ra,0x1
 1a2:	8a6080e7          	jalr	-1882(ra) # a44 <printf>
      break;
 1a6:	b749                	j	128 <ls+0x74>
 1a8:	25313423          	sd	s3,584(sp)
 1ac:	25413023          	sd	s4,576(sp)
 1b0:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
 1b4:	85ca                	mv	a1,s2
 1b6:	dc040513          	addi	a0,s0,-576
 1ba:	00000097          	auipc	ra,0x0
 1be:	13c080e7          	jalr	316(ra) # 2f6 <strcpy>
    p = buf+strlen(buf);
 1c2:	dc040513          	addi	a0,s0,-576
 1c6:	00000097          	auipc	ra,0x0
 1ca:	178080e7          	jalr	376(ra) # 33e <strlen>
 1ce:	1502                	slli	a0,a0,0x20
 1d0:	9101                	srli	a0,a0,0x20
 1d2:	dc040793          	addi	a5,s0,-576
 1d6:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1da:	00190993          	addi	s3,s2,1
 1de:	02f00793          	li	a5,47
 1e2:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1e6:	00001a17          	auipc	s4,0x1
 1ea:	cc2a0a13          	addi	s4,s4,-830 # ea8 <ithread_join+0xa6>
        printf("ls: cannot stat %s\n", buf);
 1ee:	00001a97          	auipc	s5,0x1
 1f2:	c7aa8a93          	addi	s5,s5,-902 # e68 <ithread_join+0x66>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f6:	a801                	j	206 <ls+0x152>
        printf("ls: cannot stat %s\n", buf);
 1f8:	dc040593          	addi	a1,s0,-576
 1fc:	8556                	mv	a0,s5
 1fe:	00001097          	auipc	ra,0x1
 202:	846080e7          	jalr	-1978(ra) # a44 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 206:	4641                	li	a2,16
 208:	db040593          	addi	a1,s0,-592
 20c:	8526                	mv	a0,s1
 20e:	00000097          	auipc	ra,0x0
 212:	478080e7          	jalr	1144(ra) # 686 <read>
 216:	47c1                	li	a5,16
 218:	04f51c63          	bne	a0,a5,270 <ls+0x1bc>
      if(de.inum == 0)
 21c:	db045783          	lhu	a5,-592(s0)
 220:	d3fd                	beqz	a5,206 <ls+0x152>
      memmove(p, de.name, DIRSIZ);
 222:	4639                	li	a2,14
 224:	db240593          	addi	a1,s0,-590
 228:	854e                	mv	a0,s3
 22a:	00000097          	auipc	ra,0x0
 22e:	2fa080e7          	jalr	762(ra) # 524 <memmove>
      p[DIRSIZ] = 0;
 232:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 236:	d9840593          	addi	a1,s0,-616
 23a:	dc040513          	addi	a0,s0,-576
 23e:	00000097          	auipc	ra,0x0
 242:	258080e7          	jalr	600(ra) # 496 <stat>
 246:	fa0549e3          	bltz	a0,1f8 <ls+0x144>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 24a:	dc040513          	addi	a0,s0,-576
 24e:	00000097          	auipc	ra,0x0
 252:	db2080e7          	jalr	-590(ra) # 0 <fmtname>
 256:	85aa                	mv	a1,a0
 258:	da843703          	ld	a4,-600(s0)
 25c:	d9c42683          	lw	a3,-612(s0)
 260:	da041603          	lh	a2,-608(s0)
 264:	8552                	mv	a0,s4
 266:	00000097          	auipc	ra,0x0
 26a:	7de080e7          	jalr	2014(ra) # a44 <printf>
 26e:	bf61                	j	206 <ls+0x152>
 270:	24813983          	ld	s3,584(sp)
 274:	24013a03          	ld	s4,576(sp)
 278:	23813a83          	ld	s5,568(sp)
 27c:	b575                	j	128 <ls+0x74>

000000000000027e <main>:

int
main(int argc, char *argv[])
{
 27e:	1101                	addi	sp,sp,-32
 280:	ec06                	sd	ra,24(sp)
 282:	e822                	sd	s0,16(sp)
 284:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 286:	4785                	li	a5,1
 288:	02a7db63          	bge	a5,a0,2be <main+0x40>
 28c:	e426                	sd	s1,8(sp)
 28e:	e04a                	sd	s2,0(sp)
 290:	00858493          	addi	s1,a1,8
 294:	ffe5091b          	addiw	s2,a0,-2
 298:	02091793          	slli	a5,s2,0x20
 29c:	01d7d913          	srli	s2,a5,0x1d
 2a0:	05c1                	addi	a1,a1,16
 2a2:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a4:	6088                	ld	a0,0(s1)
 2a6:	00000097          	auipc	ra,0x0
 2aa:	e0e080e7          	jalr	-498(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2ae:	04a1                	addi	s1,s1,8
 2b0:	ff249ae3          	bne	s1,s2,2a4 <main+0x26>
  exit(0);
 2b4:	4501                	li	a0,0
 2b6:	00000097          	auipc	ra,0x0
 2ba:	3b8080e7          	jalr	952(ra) # 66e <exit>
 2be:	e426                	sd	s1,8(sp)
 2c0:	e04a                	sd	s2,0(sp)
    ls(".");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	bf650513          	addi	a0,a0,-1034 # eb8 <ithread_join+0xb6>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	dea080e7          	jalr	-534(ra) # b4 <ls>
    exit(0);
 2d2:	4501                	li	a0,0
 2d4:	00000097          	auipc	ra,0x0
 2d8:	39a080e7          	jalr	922(ra) # 66e <exit>

00000000000002dc <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2e4:	00000097          	auipc	ra,0x0
 2e8:	f9a080e7          	jalr	-102(ra) # 27e <main>
  exit(0);
 2ec:	4501                	li	a0,0
 2ee:	00000097          	auipc	ra,0x0
 2f2:	380080e7          	jalr	896(ra) # 66e <exit>

00000000000002f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2fc:	87aa                	mv	a5,a0
 2fe:	0585                	addi	a1,a1,1
 300:	0785                	addi	a5,a5,1
 302:	fff5c703          	lbu	a4,-1(a1)
 306:	fee78fa3          	sb	a4,-1(a5)
 30a:	fb75                	bnez	a4,2fe <strcpy+0x8>
    ;
  return os;
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret

0000000000000312 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 312:	1141                	addi	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 318:	00054783          	lbu	a5,0(a0)
 31c:	cb91                	beqz	a5,330 <strcmp+0x1e>
 31e:	0005c703          	lbu	a4,0(a1)
 322:	00f71763          	bne	a4,a5,330 <strcmp+0x1e>
    p++, q++;
 326:	0505                	addi	a0,a0,1
 328:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 32a:	00054783          	lbu	a5,0(a0)
 32e:	fbe5                	bnez	a5,31e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 330:	0005c503          	lbu	a0,0(a1)
}
 334:	40a7853b          	subw	a0,a5,a0
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <strlen>:

uint
strlen(const char *s)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e422                	sd	s0,8(sp)
 342:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 344:	00054783          	lbu	a5,0(a0)
 348:	cf91                	beqz	a5,364 <strlen+0x26>
 34a:	0505                	addi	a0,a0,1
 34c:	87aa                	mv	a5,a0
 34e:	86be                	mv	a3,a5
 350:	0785                	addi	a5,a5,1
 352:	fff7c703          	lbu	a4,-1(a5)
 356:	ff65                	bnez	a4,34e <strlen+0x10>
 358:	40a6853b          	subw	a0,a3,a0
 35c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
  for(n = 0; s[n]; n++)
 364:	4501                	li	a0,0
 366:	bfe5                	j	35e <strlen+0x20>

0000000000000368 <memset>:

void*
memset(void *dst, int c, uint n)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 36e:	ca19                	beqz	a2,384 <memset+0x1c>
 370:	87aa                	mv	a5,a0
 372:	1602                	slli	a2,a2,0x20
 374:	9201                	srli	a2,a2,0x20
 376:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 37a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 37e:	0785                	addi	a5,a5,1
 380:	fee79de3          	bne	a5,a4,37a <memset+0x12>
  }
  return dst;
}
 384:	6422                	ld	s0,8(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <strchr>:

char*
strchr(const char *s, char c)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e422                	sd	s0,8(sp)
 38e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 390:	00054783          	lbu	a5,0(a0)
 394:	cb99                	beqz	a5,3aa <strchr+0x20>
    if(*s == c)
 396:	00f58763          	beq	a1,a5,3a4 <strchr+0x1a>
  for(; *s; s++)
 39a:	0505                	addi	a0,a0,1
 39c:	00054783          	lbu	a5,0(a0)
 3a0:	fbfd                	bnez	a5,396 <strchr+0xc>
      return (char*)s;
  return 0;
 3a2:	4501                	li	a0,0
}
 3a4:	6422                	ld	s0,8(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret
  return 0;
 3aa:	4501                	li	a0,0
 3ac:	bfe5                	j	3a4 <strchr+0x1a>

00000000000003ae <gets>:

char*
gets(char *buf, int max)
{
 3ae:	711d                	addi	sp,sp,-96
 3b0:	ec86                	sd	ra,88(sp)
 3b2:	e8a2                	sd	s0,80(sp)
 3b4:	e4a6                	sd	s1,72(sp)
 3b6:	e0ca                	sd	s2,64(sp)
 3b8:	fc4e                	sd	s3,56(sp)
 3ba:	f852                	sd	s4,48(sp)
 3bc:	f456                	sd	s5,40(sp)
 3be:	f05a                	sd	s6,32(sp)
 3c0:	ec5e                	sd	s7,24(sp)
 3c2:	1080                	addi	s0,sp,96
 3c4:	8baa                	mv	s7,a0
 3c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c8:	892a                	mv	s2,a0
 3ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3cc:	4aa9                	li	s5,10
 3ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3d0:	89a6                	mv	s3,s1
 3d2:	2485                	addiw	s1,s1,1
 3d4:	0344d863          	bge	s1,s4,404 <gets+0x56>
    cc = read(0, &c, 1);
 3d8:	4605                	li	a2,1
 3da:	faf40593          	addi	a1,s0,-81
 3de:	4501                	li	a0,0
 3e0:	00000097          	auipc	ra,0x0
 3e4:	2a6080e7          	jalr	678(ra) # 686 <read>
    if(cc < 1)
 3e8:	00a05e63          	blez	a0,404 <gets+0x56>
    buf[i++] = c;
 3ec:	faf44783          	lbu	a5,-81(s0)
 3f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3f4:	01578763          	beq	a5,s5,402 <gets+0x54>
 3f8:	0905                	addi	s2,s2,1
 3fa:	fd679be3          	bne	a5,s6,3d0 <gets+0x22>
    buf[i++] = c;
 3fe:	89a6                	mv	s3,s1
 400:	a011                	j	404 <gets+0x56>
 402:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 404:	99de                	add	s3,s3,s7
 406:	00098023          	sb	zero,0(s3)
  return buf;
}
 40a:	855e                	mv	a0,s7
 40c:	60e6                	ld	ra,88(sp)
 40e:	6446                	ld	s0,80(sp)
 410:	64a6                	ld	s1,72(sp)
 412:	6906                	ld	s2,64(sp)
 414:	79e2                	ld	s3,56(sp)
 416:	7a42                	ld	s4,48(sp)
 418:	7aa2                	ld	s5,40(sp)
 41a:	7b02                	ld	s6,32(sp)
 41c:	6be2                	ld	s7,24(sp)
 41e:	6125                	addi	sp,sp,96
 420:	8082                	ret

0000000000000422 <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 422:	711d                	addi	sp,sp,-96
 424:	ec86                	sd	ra,88(sp)
 426:	e8a2                	sd	s0,80(sp)
 428:	e4a6                	sd	s1,72(sp)
 42a:	e0ca                	sd	s2,64(sp)
 42c:	fc4e                	sd	s3,56(sp)
 42e:	f852                	sd	s4,48(sp)
 430:	f456                	sd	s5,40(sp)
 432:	f05a                	sd	s6,32(sp)
 434:	ec5e                	sd	s7,24(sp)
 436:	1080                	addi	s0,sp,96
 438:	8baa                	mv	s7,a0
 43a:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 43c:	892a                	mv	s2,a0
 43e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 440:	4aa9                	li	s5,10
 442:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 444:	8a26                	mv	s4,s1
 446:	2485                	addiw	s1,s1,1
 448:	0334d863          	bge	s1,s3,478 <fgetstdin+0x56>
    cc = read(0, &c, 1);
 44c:	4605                	li	a2,1
 44e:	faf40593          	addi	a1,s0,-81
 452:	4501                	li	a0,0
 454:	00000097          	auipc	ra,0x0
 458:	232080e7          	jalr	562(ra) # 686 <read>
    if(cc < 1)
 45c:	00a05e63          	blez	a0,478 <fgetstdin+0x56>
    buf[i++] = c;
 460:	faf44783          	lbu	a5,-81(s0)
 464:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 468:	01578763          	beq	a5,s5,476 <fgetstdin+0x54>
 46c:	0905                	addi	s2,s2,1
 46e:	fd679be3          	bne	a5,s6,444 <fgetstdin+0x22>
    buf[i++] = c;
 472:	8a26                	mv	s4,s1
 474:	a011                	j	478 <fgetstdin+0x56>
 476:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 478:	9bd2                	add	s7,s7,s4
 47a:	000b8023          	sb	zero,0(s7)
  return i;
}
 47e:	8552                	mv	a0,s4
 480:	60e6                	ld	ra,88(sp)
 482:	6446                	ld	s0,80(sp)
 484:	64a6                	ld	s1,72(sp)
 486:	6906                	ld	s2,64(sp)
 488:	79e2                	ld	s3,56(sp)
 48a:	7a42                	ld	s4,48(sp)
 48c:	7aa2                	ld	s5,40(sp)
 48e:	7b02                	ld	s6,32(sp)
 490:	6be2                	ld	s7,24(sp)
 492:	6125                	addi	sp,sp,96
 494:	8082                	ret

0000000000000496 <stat>:

int
stat(const char *n, struct stat *st)
{
 496:	1101                	addi	sp,sp,-32
 498:	ec06                	sd	ra,24(sp)
 49a:	e822                	sd	s0,16(sp)
 49c:	e04a                	sd	s2,0(sp)
 49e:	1000                	addi	s0,sp,32
 4a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a2:	4581                	li	a1,0
 4a4:	00000097          	auipc	ra,0x0
 4a8:	20a080e7          	jalr	522(ra) # 6ae <open>
  if(fd < 0)
 4ac:	02054663          	bltz	a0,4d8 <stat+0x42>
 4b0:	e426                	sd	s1,8(sp)
 4b2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4b4:	85ca                	mv	a1,s2
 4b6:	00000097          	auipc	ra,0x0
 4ba:	210080e7          	jalr	528(ra) # 6c6 <fstat>
 4be:	892a                	mv	s2,a0
  close(fd);
 4c0:	8526                	mv	a0,s1
 4c2:	00000097          	auipc	ra,0x0
 4c6:	1d4080e7          	jalr	468(ra) # 696 <close>
  return r;
 4ca:	64a2                	ld	s1,8(sp)
}
 4cc:	854a                	mv	a0,s2
 4ce:	60e2                	ld	ra,24(sp)
 4d0:	6442                	ld	s0,16(sp)
 4d2:	6902                	ld	s2,0(sp)
 4d4:	6105                	addi	sp,sp,32
 4d6:	8082                	ret
    return -1;
 4d8:	597d                	li	s2,-1
 4da:	bfcd                	j	4cc <stat+0x36>

00000000000004dc <atoi>:

int
atoi(const char *s)
{
 4dc:	1141                	addi	sp,sp,-16
 4de:	e422                	sd	s0,8(sp)
 4e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4e2:	00054683          	lbu	a3,0(a0)
 4e6:	fd06879b          	addiw	a5,a3,-48
 4ea:	0ff7f793          	zext.b	a5,a5
 4ee:	4625                	li	a2,9
 4f0:	02f66863          	bltu	a2,a5,520 <atoi+0x44>
 4f4:	872a                	mv	a4,a0
  n = 0;
 4f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4f8:	0705                	addi	a4,a4,1
 4fa:	0025179b          	slliw	a5,a0,0x2
 4fe:	9fa9                	addw	a5,a5,a0
 500:	0017979b          	slliw	a5,a5,0x1
 504:	9fb5                	addw	a5,a5,a3
 506:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 50a:	00074683          	lbu	a3,0(a4)
 50e:	fd06879b          	addiw	a5,a3,-48
 512:	0ff7f793          	zext.b	a5,a5
 516:	fef671e3          	bgeu	a2,a5,4f8 <atoi+0x1c>
  return n;
}
 51a:	6422                	ld	s0,8(sp)
 51c:	0141                	addi	sp,sp,16
 51e:	8082                	ret
  n = 0;
 520:	4501                	li	a0,0
 522:	bfe5                	j	51a <atoi+0x3e>

0000000000000524 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 524:	1141                	addi	sp,sp,-16
 526:	e422                	sd	s0,8(sp)
 528:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 52a:	02b57463          	bgeu	a0,a1,552 <memmove+0x2e>
    while(n-- > 0)
 52e:	00c05f63          	blez	a2,54c <memmove+0x28>
 532:	1602                	slli	a2,a2,0x20
 534:	9201                	srli	a2,a2,0x20
 536:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 53a:	872a                	mv	a4,a0
      *dst++ = *src++;
 53c:	0585                	addi	a1,a1,1
 53e:	0705                	addi	a4,a4,1
 540:	fff5c683          	lbu	a3,-1(a1)
 544:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 548:	fef71ae3          	bne	a4,a5,53c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 54c:	6422                	ld	s0,8(sp)
 54e:	0141                	addi	sp,sp,16
 550:	8082                	ret
    dst += n;
 552:	00c50733          	add	a4,a0,a2
    src += n;
 556:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 558:	fec05ae3          	blez	a2,54c <memmove+0x28>
 55c:	fff6079b          	addiw	a5,a2,-1
 560:	1782                	slli	a5,a5,0x20
 562:	9381                	srli	a5,a5,0x20
 564:	fff7c793          	not	a5,a5
 568:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 56a:	15fd                	addi	a1,a1,-1
 56c:	177d                	addi	a4,a4,-1
 56e:	0005c683          	lbu	a3,0(a1)
 572:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 576:	fee79ae3          	bne	a5,a4,56a <memmove+0x46>
 57a:	bfc9                	j	54c <memmove+0x28>

000000000000057c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 57c:	1141                	addi	sp,sp,-16
 57e:	e422                	sd	s0,8(sp)
 580:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 582:	ca05                	beqz	a2,5b2 <memcmp+0x36>
 584:	fff6069b          	addiw	a3,a2,-1
 588:	1682                	slli	a3,a3,0x20
 58a:	9281                	srli	a3,a3,0x20
 58c:	0685                	addi	a3,a3,1
 58e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 590:	00054783          	lbu	a5,0(a0)
 594:	0005c703          	lbu	a4,0(a1)
 598:	00e79863          	bne	a5,a4,5a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 59c:	0505                	addi	a0,a0,1
    p2++;
 59e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5a0:	fed518e3          	bne	a0,a3,590 <memcmp+0x14>
  }
  return 0;
 5a4:	4501                	li	a0,0
 5a6:	a019                	j	5ac <memcmp+0x30>
      return *p1 - *p2;
 5a8:	40e7853b          	subw	a0,a5,a4
}
 5ac:	6422                	ld	s0,8(sp)
 5ae:	0141                	addi	sp,sp,16
 5b0:	8082                	ret
  return 0;
 5b2:	4501                	li	a0,0
 5b4:	bfe5                	j	5ac <memcmp+0x30>

00000000000005b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5b6:	1141                	addi	sp,sp,-16
 5b8:	e406                	sd	ra,8(sp)
 5ba:	e022                	sd	s0,0(sp)
 5bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 5be:	00000097          	auipc	ra,0x0
 5c2:	f66080e7          	jalr	-154(ra) # 524 <memmove>
}
 5c6:	60a2                	ld	ra,8(sp)
 5c8:	6402                	ld	s0,0(sp)
 5ca:	0141                	addi	sp,sp,16
 5cc:	8082                	ret

00000000000005ce <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 5ce:	1141                	addi	sp,sp,-16
 5d0:	e422                	sd	s0,8(sp)
 5d2:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 5d4:	00054783          	lbu	a5,0(a0)
 5d8:	cfbd                	beqz	a5,656 <inet_addr+0x88>
  int dots = 0;
 5da:	4801                	li	a6,0
  int digits = 0;
 5dc:	4601                	li	a2,0
  int octet = 0;
 5de:	4681                	li	a3,0
  uint result = 0;
 5e0:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 5e2:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 5e4:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 5e8:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 5ea:	4301                	li	t1,0
      if (octet > 255)
 5ec:	0ff00e13          	li	t3,255
 5f0:	a015                	j	614 <inet_addr+0x46>
    } else if (*s == '.') {
 5f2:	07d79463          	bne	a5,t4,65a <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 5f6:	c625                	beqz	a2,65e <inet_addr+0x90>
 5f8:	07e80563          	beq	a6,t5,662 <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 5fc:	0085959b          	slliw	a1,a1,0x8
 600:	8ecd                	or	a3,a3,a1
 602:	0006859b          	sext.w	a1,a3
      dots++;
 606:	2805                	addiw	a6,a6,1
      digits = 0;
 608:	861a                	mv	a2,t1
      octet = 0;
 60a:	869a                	mv	a3,t1
  for (; *s; s++) {
 60c:	0505                	addi	a0,a0,1
 60e:	00054783          	lbu	a5,0(a0)
 612:	c79d                	beqz	a5,640 <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 614:	fd07871b          	addiw	a4,a5,-48
 618:	0ff77713          	zext.b	a4,a4
 61c:	fce8ebe3          	bltu	a7,a4,5f2 <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 620:	0026971b          	slliw	a4,a3,0x2
 624:	9f35                	addw	a4,a4,a3
 626:	0017171b          	slliw	a4,a4,0x1
 62a:	fd07879b          	addiw	a5,a5,-48
 62e:	00e786bb          	addw	a3,a5,a4
      digits++;
 632:	2605                	addiw	a2,a2,1
      if (octet > 255)
 634:	fcde5ce3          	bge	t3,a3,60c <inet_addr+0x3e>
        return 0;
 638:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 63a:	6422                	ld	s0,8(sp)
 63c:	0141                	addi	sp,sp,16
 63e:	8082                	ret
    return 0;
 640:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 642:	de65                	beqz	a2,63a <inet_addr+0x6c>
 644:	478d                	li	a5,3
 646:	fef81ae3          	bne	a6,a5,63a <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 64a:	0085959b          	slliw	a1,a1,0x8
 64e:	8ecd                	or	a3,a3,a1
 650:	0006851b          	sext.w	a0,a3
  return result;
 654:	b7dd                	j	63a <inet_addr+0x6c>
    return 0;
 656:	4501                	li	a0,0
 658:	b7cd                	j	63a <inet_addr+0x6c>
      return 0;
 65a:	4501                	li	a0,0
 65c:	bff9                	j	63a <inet_addr+0x6c>
        return 0;
 65e:	4501                	li	a0,0
 660:	bfe9                	j	63a <inet_addr+0x6c>
 662:	4501                	li	a0,0
 664:	bfd9                	j	63a <inet_addr+0x6c>

0000000000000666 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 666:	4885                	li	a7,1
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <exit>:
.global exit
exit:
 li a7, SYS_exit
 66e:	4889                	li	a7,2
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <wait>:
.global wait
wait:
 li a7, SYS_wait
 676:	488d                	li	a7,3
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 67e:	4891                	li	a7,4
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <read>:
.global read
read:
 li a7, SYS_read
 686:	4895                	li	a7,5
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <write>:
.global write
write:
 li a7, SYS_write
 68e:	48c1                	li	a7,16
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <close>:
.global close
close:
 li a7, SYS_close
 696:	48d5                	li	a7,21
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <kill>:
.global kill
kill:
 li a7, SYS_kill
 69e:	4899                	li	a7,6
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 6a6:	489d                	li	a7,7
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <open>:
.global open
open:
 li a7, SYS_open
 6ae:	48bd                	li	a7,15
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6b6:	48c5                	li	a7,17
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6be:	48c9                	li	a7,18
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6c6:	48a1                	li	a7,8
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <link>:
.global link
link:
 li a7, SYS_link
 6ce:	48cd                	li	a7,19
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6d6:	48d1                	li	a7,20
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6de:	48a5                	li	a7,9
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6e6:	48a9                	li	a7,10
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6ee:	48ad                	li	a7,11
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6f6:	48b1                	li	a7,12
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6fe:	48b5                	li	a7,13
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 706:	48b9                	li	a7,14
 ecall
 708:	00000073          	ecall
 ret
 70c:	8082                	ret

000000000000070e <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 70e:	48d9                	li	a7,22
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 716:	48dd                	li	a7,23
 ecall
 718:	00000073          	ecall
 ret
 71c:	8082                	ret

000000000000071e <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 71e:	48e1                	li	a7,24
 ecall
 720:	00000073          	ecall
 ret
 724:	8082                	ret

0000000000000726 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 726:	48e5                	li	a7,25
 ecall
 728:	00000073          	ecall
 ret
 72c:	8082                	ret

000000000000072e <socket>:
.global socket
socket:
 li a7, SYS_socket
 72e:	48e9                	li	a7,26
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <bind>:
.global bind
bind:
 li a7, SYS_bind
 736:	48ed                	li	a7,27
 ecall
 738:	00000073          	ecall
 ret
 73c:	8082                	ret

000000000000073e <accept>:
.global accept
accept:
 li a7, SYS_accept
 73e:	48f5                	li	a7,29
 ecall
 740:	00000073          	ecall
 ret
 744:	8082                	ret

0000000000000746 <listen>:
.global listen
listen:
 li a7, SYS_listen
 746:	48f1                	li	a7,28
 ecall
 748:	00000073          	ecall
 ret
 74c:	8082                	ret

000000000000074e <connect>:
.global connect
connect:
 li a7, SYS_connect
 74e:	48f9                	li	a7,30
 ecall
 750:	00000073          	ecall
 ret
 754:	8082                	ret

0000000000000756 <send>:
.global send
send:
 li a7, SYS_send
 756:	48fd                	li	a7,31
 ecall
 758:	00000073          	ecall
 ret
 75c:	8082                	ret

000000000000075e <recv>:
.global recv
recv:
 li a7, SYS_recv
 75e:	02000893          	li	a7,32
 ecall
 762:	00000073          	ecall
 ret
 766:	8082                	ret

0000000000000768 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 768:	02100893          	li	a7,33
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 772:	02200893          	li	a7,34
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 77c:	1101                	addi	sp,sp,-32
 77e:	ec06                	sd	ra,24(sp)
 780:	e822                	sd	s0,16(sp)
 782:	1000                	addi	s0,sp,32
 784:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 788:	4605                	li	a2,1
 78a:	fef40593          	addi	a1,s0,-17
 78e:	00000097          	auipc	ra,0x0
 792:	f00080e7          	jalr	-256(ra) # 68e <write>
}
 796:	60e2                	ld	ra,24(sp)
 798:	6442                	ld	s0,16(sp)
 79a:	6105                	addi	sp,sp,32
 79c:	8082                	ret

000000000000079e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 79e:	7139                	addi	sp,sp,-64
 7a0:	fc06                	sd	ra,56(sp)
 7a2:	f822                	sd	s0,48(sp)
 7a4:	f426                	sd	s1,40(sp)
 7a6:	0080                	addi	s0,sp,64
 7a8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7aa:	c299                	beqz	a3,7b0 <printint+0x12>
 7ac:	0805cb63          	bltz	a1,842 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7b0:	2581                	sext.w	a1,a1
  neg = 0;
 7b2:	4881                	li	a7,0
 7b4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7b8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7ba:	2601                	sext.w	a2,a2
 7bc:	00000517          	auipc	a0,0x0
 7c0:	79450513          	addi	a0,a0,1940 # f50 <digits>
 7c4:	883a                	mv	a6,a4
 7c6:	2705                	addiw	a4,a4,1
 7c8:	02c5f7bb          	remuw	a5,a1,a2
 7cc:	1782                	slli	a5,a5,0x20
 7ce:	9381                	srli	a5,a5,0x20
 7d0:	97aa                	add	a5,a5,a0
 7d2:	0007c783          	lbu	a5,0(a5)
 7d6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7da:	0005879b          	sext.w	a5,a1
 7de:	02c5d5bb          	divuw	a1,a1,a2
 7e2:	0685                	addi	a3,a3,1
 7e4:	fec7f0e3          	bgeu	a5,a2,7c4 <printint+0x26>
  if(neg)
 7e8:	00088c63          	beqz	a7,800 <printint+0x62>
    buf[i++] = '-';
 7ec:	fd070793          	addi	a5,a4,-48
 7f0:	00878733          	add	a4,a5,s0
 7f4:	02d00793          	li	a5,45
 7f8:	fef70823          	sb	a5,-16(a4)
 7fc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 800:	02e05c63          	blez	a4,838 <printint+0x9a>
 804:	f04a                	sd	s2,32(sp)
 806:	ec4e                	sd	s3,24(sp)
 808:	fc040793          	addi	a5,s0,-64
 80c:	00e78933          	add	s2,a5,a4
 810:	fff78993          	addi	s3,a5,-1
 814:	99ba                	add	s3,s3,a4
 816:	377d                	addiw	a4,a4,-1
 818:	1702                	slli	a4,a4,0x20
 81a:	9301                	srli	a4,a4,0x20
 81c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 820:	fff94583          	lbu	a1,-1(s2)
 824:	8526                	mv	a0,s1
 826:	00000097          	auipc	ra,0x0
 82a:	f56080e7          	jalr	-170(ra) # 77c <putc>
  while(--i >= 0)
 82e:	197d                	addi	s2,s2,-1
 830:	ff3918e3          	bne	s2,s3,820 <printint+0x82>
 834:	7902                	ld	s2,32(sp)
 836:	69e2                	ld	s3,24(sp)
}
 838:	70e2                	ld	ra,56(sp)
 83a:	7442                	ld	s0,48(sp)
 83c:	74a2                	ld	s1,40(sp)
 83e:	6121                	addi	sp,sp,64
 840:	8082                	ret
    x = -xx;
 842:	40b005bb          	negw	a1,a1
    neg = 1;
 846:	4885                	li	a7,1
    x = -xx;
 848:	b7b5                	j	7b4 <printint+0x16>

000000000000084a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 84a:	715d                	addi	sp,sp,-80
 84c:	e486                	sd	ra,72(sp)
 84e:	e0a2                	sd	s0,64(sp)
 850:	f84a                	sd	s2,48(sp)
 852:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 854:	0005c903          	lbu	s2,0(a1)
 858:	1a090a63          	beqz	s2,a0c <vprintf+0x1c2>
 85c:	fc26                	sd	s1,56(sp)
 85e:	f44e                	sd	s3,40(sp)
 860:	f052                	sd	s4,32(sp)
 862:	ec56                	sd	s5,24(sp)
 864:	e85a                	sd	s6,16(sp)
 866:	e45e                	sd	s7,8(sp)
 868:	8aaa                	mv	s5,a0
 86a:	8bb2                	mv	s7,a2
 86c:	00158493          	addi	s1,a1,1
  state = 0;
 870:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 872:	02500a13          	li	s4,37
 876:	4b55                	li	s6,21
 878:	a839                	j	896 <vprintf+0x4c>
        putc(fd, c);
 87a:	85ca                	mv	a1,s2
 87c:	8556                	mv	a0,s5
 87e:	00000097          	auipc	ra,0x0
 882:	efe080e7          	jalr	-258(ra) # 77c <putc>
 886:	a019                	j	88c <vprintf+0x42>
    } else if(state == '%'){
 888:	01498d63          	beq	s3,s4,8a2 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 88c:	0485                	addi	s1,s1,1
 88e:	fff4c903          	lbu	s2,-1(s1)
 892:	16090763          	beqz	s2,a00 <vprintf+0x1b6>
    if(state == 0){
 896:	fe0999e3          	bnez	s3,888 <vprintf+0x3e>
      if(c == '%'){
 89a:	ff4910e3          	bne	s2,s4,87a <vprintf+0x30>
        state = '%';
 89e:	89d2                	mv	s3,s4
 8a0:	b7f5                	j	88c <vprintf+0x42>
      if(c == 'd'){
 8a2:	13490463          	beq	s2,s4,9ca <vprintf+0x180>
 8a6:	f9d9079b          	addiw	a5,s2,-99
 8aa:	0ff7f793          	zext.b	a5,a5
 8ae:	12fb6763          	bltu	s6,a5,9dc <vprintf+0x192>
 8b2:	f9d9079b          	addiw	a5,s2,-99
 8b6:	0ff7f713          	zext.b	a4,a5
 8ba:	12eb6163          	bltu	s6,a4,9dc <vprintf+0x192>
 8be:	00271793          	slli	a5,a4,0x2
 8c2:	00000717          	auipc	a4,0x0
 8c6:	63670713          	addi	a4,a4,1590 # ef8 <ithread_join+0xf6>
 8ca:	97ba                	add	a5,a5,a4
 8cc:	439c                	lw	a5,0(a5)
 8ce:	97ba                	add	a5,a5,a4
 8d0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 8d2:	008b8913          	addi	s2,s7,8
 8d6:	4685                	li	a3,1
 8d8:	4629                	li	a2,10
 8da:	000ba583          	lw	a1,0(s7)
 8de:	8556                	mv	a0,s5
 8e0:	00000097          	auipc	ra,0x0
 8e4:	ebe080e7          	jalr	-322(ra) # 79e <printint>
 8e8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8ea:	4981                	li	s3,0
 8ec:	b745                	j	88c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ee:	008b8913          	addi	s2,s7,8
 8f2:	4681                	li	a3,0
 8f4:	4629                	li	a2,10
 8f6:	000ba583          	lw	a1,0(s7)
 8fa:	8556                	mv	a0,s5
 8fc:	00000097          	auipc	ra,0x0
 900:	ea2080e7          	jalr	-350(ra) # 79e <printint>
 904:	8bca                	mv	s7,s2
      state = 0;
 906:	4981                	li	s3,0
 908:	b751                	j	88c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 90a:	008b8913          	addi	s2,s7,8
 90e:	4681                	li	a3,0
 910:	4641                	li	a2,16
 912:	000ba583          	lw	a1,0(s7)
 916:	8556                	mv	a0,s5
 918:	00000097          	auipc	ra,0x0
 91c:	e86080e7          	jalr	-378(ra) # 79e <printint>
 920:	8bca                	mv	s7,s2
      state = 0;
 922:	4981                	li	s3,0
 924:	b7a5                	j	88c <vprintf+0x42>
 926:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 928:	008b8c13          	addi	s8,s7,8
 92c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 930:	03000593          	li	a1,48
 934:	8556                	mv	a0,s5
 936:	00000097          	auipc	ra,0x0
 93a:	e46080e7          	jalr	-442(ra) # 77c <putc>
  putc(fd, 'x');
 93e:	07800593          	li	a1,120
 942:	8556                	mv	a0,s5
 944:	00000097          	auipc	ra,0x0
 948:	e38080e7          	jalr	-456(ra) # 77c <putc>
 94c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 94e:	00000b97          	auipc	s7,0x0
 952:	602b8b93          	addi	s7,s7,1538 # f50 <digits>
 956:	03c9d793          	srli	a5,s3,0x3c
 95a:	97de                	add	a5,a5,s7
 95c:	0007c583          	lbu	a1,0(a5)
 960:	8556                	mv	a0,s5
 962:	00000097          	auipc	ra,0x0
 966:	e1a080e7          	jalr	-486(ra) # 77c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 96a:	0992                	slli	s3,s3,0x4
 96c:	397d                	addiw	s2,s2,-1
 96e:	fe0914e3          	bnez	s2,956 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 972:	8be2                	mv	s7,s8
      state = 0;
 974:	4981                	li	s3,0
 976:	6c02                	ld	s8,0(sp)
 978:	bf11                	j	88c <vprintf+0x42>
        s = va_arg(ap, char*);
 97a:	008b8993          	addi	s3,s7,8
 97e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 982:	02090163          	beqz	s2,9a4 <vprintf+0x15a>
        while(*s != 0){
 986:	00094583          	lbu	a1,0(s2)
 98a:	c9a5                	beqz	a1,9fa <vprintf+0x1b0>
          putc(fd, *s);
 98c:	8556                	mv	a0,s5
 98e:	00000097          	auipc	ra,0x0
 992:	dee080e7          	jalr	-530(ra) # 77c <putc>
          s++;
 996:	0905                	addi	s2,s2,1
        while(*s != 0){
 998:	00094583          	lbu	a1,0(s2)
 99c:	f9e5                	bnez	a1,98c <vprintf+0x142>
        s = va_arg(ap, char*);
 99e:	8bce                	mv	s7,s3
      state = 0;
 9a0:	4981                	li	s3,0
 9a2:	b5ed                	j	88c <vprintf+0x42>
          s = "(null)";
 9a4:	00000917          	auipc	s2,0x0
 9a8:	51c90913          	addi	s2,s2,1308 # ec0 <ithread_join+0xbe>
        while(*s != 0){
 9ac:	02800593          	li	a1,40
 9b0:	bff1                	j	98c <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 9b2:	008b8913          	addi	s2,s7,8
 9b6:	000bc583          	lbu	a1,0(s7)
 9ba:	8556                	mv	a0,s5
 9bc:	00000097          	auipc	ra,0x0
 9c0:	dc0080e7          	jalr	-576(ra) # 77c <putc>
 9c4:	8bca                	mv	s7,s2
      state = 0;
 9c6:	4981                	li	s3,0
 9c8:	b5d1                	j	88c <vprintf+0x42>
        putc(fd, c);
 9ca:	02500593          	li	a1,37
 9ce:	8556                	mv	a0,s5
 9d0:	00000097          	auipc	ra,0x0
 9d4:	dac080e7          	jalr	-596(ra) # 77c <putc>
      state = 0;
 9d8:	4981                	li	s3,0
 9da:	bd4d                	j	88c <vprintf+0x42>
        putc(fd, '%');
 9dc:	02500593          	li	a1,37
 9e0:	8556                	mv	a0,s5
 9e2:	00000097          	auipc	ra,0x0
 9e6:	d9a080e7          	jalr	-614(ra) # 77c <putc>
        putc(fd, c);
 9ea:	85ca                	mv	a1,s2
 9ec:	8556                	mv	a0,s5
 9ee:	00000097          	auipc	ra,0x0
 9f2:	d8e080e7          	jalr	-626(ra) # 77c <putc>
      state = 0;
 9f6:	4981                	li	s3,0
 9f8:	bd51                	j	88c <vprintf+0x42>
        s = va_arg(ap, char*);
 9fa:	8bce                	mv	s7,s3
      state = 0;
 9fc:	4981                	li	s3,0
 9fe:	b579                	j	88c <vprintf+0x42>
 a00:	74e2                	ld	s1,56(sp)
 a02:	79a2                	ld	s3,40(sp)
 a04:	7a02                	ld	s4,32(sp)
 a06:	6ae2                	ld	s5,24(sp)
 a08:	6b42                	ld	s6,16(sp)
 a0a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 a0c:	60a6                	ld	ra,72(sp)
 a0e:	6406                	ld	s0,64(sp)
 a10:	7942                	ld	s2,48(sp)
 a12:	6161                	addi	sp,sp,80
 a14:	8082                	ret

0000000000000a16 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a16:	715d                	addi	sp,sp,-80
 a18:	ec06                	sd	ra,24(sp)
 a1a:	e822                	sd	s0,16(sp)
 a1c:	1000                	addi	s0,sp,32
 a1e:	e010                	sd	a2,0(s0)
 a20:	e414                	sd	a3,8(s0)
 a22:	e818                	sd	a4,16(s0)
 a24:	ec1c                	sd	a5,24(s0)
 a26:	03043023          	sd	a6,32(s0)
 a2a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a2e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a32:	8622                	mv	a2,s0
 a34:	00000097          	auipc	ra,0x0
 a38:	e16080e7          	jalr	-490(ra) # 84a <vprintf>
}
 a3c:	60e2                	ld	ra,24(sp)
 a3e:	6442                	ld	s0,16(sp)
 a40:	6161                	addi	sp,sp,80
 a42:	8082                	ret

0000000000000a44 <printf>:

void
printf(const char *fmt, ...)
{
 a44:	711d                	addi	sp,sp,-96
 a46:	ec06                	sd	ra,24(sp)
 a48:	e822                	sd	s0,16(sp)
 a4a:	1000                	addi	s0,sp,32
 a4c:	e40c                	sd	a1,8(s0)
 a4e:	e810                	sd	a2,16(s0)
 a50:	ec14                	sd	a3,24(s0)
 a52:	f018                	sd	a4,32(s0)
 a54:	f41c                	sd	a5,40(s0)
 a56:	03043823          	sd	a6,48(s0)
 a5a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a5e:	00840613          	addi	a2,s0,8
 a62:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a66:	85aa                	mv	a1,a0
 a68:	4505                	li	a0,1
 a6a:	00000097          	auipc	ra,0x0
 a6e:	de0080e7          	jalr	-544(ra) # 84a <vprintf>
}
 a72:	60e2                	ld	ra,24(sp)
 a74:	6442                	ld	s0,16(sp)
 a76:	6125                	addi	sp,sp,96
 a78:	8082                	ret

0000000000000a7a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a7a:	1141                	addi	sp,sp,-16
 a7c:	e422                	sd	s0,8(sp)
 a7e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a80:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a84:	00000797          	auipc	a5,0x0
 a88:	58c7b783          	ld	a5,1420(a5) # 1010 <freep>
 a8c:	a02d                	j	ab6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a8e:	4618                	lw	a4,8(a2)
 a90:	9f2d                	addw	a4,a4,a1
 a92:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a96:	6398                	ld	a4,0(a5)
 a98:	6310                	ld	a2,0(a4)
 a9a:	a83d                	j	ad8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a9c:	ff852703          	lw	a4,-8(a0)
 aa0:	9f31                	addw	a4,a4,a2
 aa2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 aa4:	ff053683          	ld	a3,-16(a0)
 aa8:	a091                	j	aec <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aaa:	6398                	ld	a4,0(a5)
 aac:	00e7e463          	bltu	a5,a4,ab4 <free+0x3a>
 ab0:	00e6ea63          	bltu	a3,a4,ac4 <free+0x4a>
{
 ab4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab6:	fed7fae3          	bgeu	a5,a3,aaa <free+0x30>
 aba:	6398                	ld	a4,0(a5)
 abc:	00e6e463          	bltu	a3,a4,ac4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac0:	fee7eae3          	bltu	a5,a4,ab4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 ac4:	ff852583          	lw	a1,-8(a0)
 ac8:	6390                	ld	a2,0(a5)
 aca:	02059813          	slli	a6,a1,0x20
 ace:	01c85713          	srli	a4,a6,0x1c
 ad2:	9736                	add	a4,a4,a3
 ad4:	fae60de3          	beq	a2,a4,a8e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ad8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 adc:	4790                	lw	a2,8(a5)
 ade:	02061593          	slli	a1,a2,0x20
 ae2:	01c5d713          	srli	a4,a1,0x1c
 ae6:	973e                	add	a4,a4,a5
 ae8:	fae68ae3          	beq	a3,a4,a9c <free+0x22>
    p->s.ptr = bp->s.ptr;
 aec:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 aee:	00000717          	auipc	a4,0x0
 af2:	52f73123          	sd	a5,1314(a4) # 1010 <freep>
}
 af6:	6422                	ld	s0,8(sp)
 af8:	0141                	addi	sp,sp,16
 afa:	8082                	ret

0000000000000afc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 afc:	7139                	addi	sp,sp,-64
 afe:	fc06                	sd	ra,56(sp)
 b00:	f822                	sd	s0,48(sp)
 b02:	f426                	sd	s1,40(sp)
 b04:	ec4e                	sd	s3,24(sp)
 b06:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b08:	02051493          	slli	s1,a0,0x20
 b0c:	9081                	srli	s1,s1,0x20
 b0e:	04bd                	addi	s1,s1,15
 b10:	8091                	srli	s1,s1,0x4
 b12:	0014899b          	addiw	s3,s1,1
 b16:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b18:	00000517          	auipc	a0,0x0
 b1c:	4f853503          	ld	a0,1272(a0) # 1010 <freep>
 b20:	c915                	beqz	a0,b54 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b22:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b24:	4798                	lw	a4,8(a5)
 b26:	08977e63          	bgeu	a4,s1,bc2 <malloc+0xc6>
 b2a:	f04a                	sd	s2,32(sp)
 b2c:	e852                	sd	s4,16(sp)
 b2e:	e456                	sd	s5,8(sp)
 b30:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b32:	8a4e                	mv	s4,s3
 b34:	0009871b          	sext.w	a4,s3
 b38:	6685                	lui	a3,0x1
 b3a:	00d77363          	bgeu	a4,a3,b40 <malloc+0x44>
 b3e:	6a05                	lui	s4,0x1
 b40:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b44:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b48:	00000917          	auipc	s2,0x0
 b4c:	4c890913          	addi	s2,s2,1224 # 1010 <freep>
  if(p == (char*)-1)
 b50:	5afd                	li	s5,-1
 b52:	a091                	j	b96 <malloc+0x9a>
 b54:	f04a                	sd	s2,32(sp)
 b56:	e852                	sd	s4,16(sp)
 b58:	e456                	sd	s5,8(sp)
 b5a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b5c:	00000797          	auipc	a5,0x0
 b60:	4e478793          	addi	a5,a5,1252 # 1040 <base>
 b64:	00000717          	auipc	a4,0x0
 b68:	4af73623          	sd	a5,1196(a4) # 1010 <freep>
 b6c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b6e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b72:	b7c1                	j	b32 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 b74:	6398                	ld	a4,0(a5)
 b76:	e118                	sd	a4,0(a0)
 b78:	a08d                	j	bda <malloc+0xde>
  hp->s.size = nu;
 b7a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b7e:	0541                	addi	a0,a0,16
 b80:	00000097          	auipc	ra,0x0
 b84:	efa080e7          	jalr	-262(ra) # a7a <free>
  return freep;
 b88:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b8c:	c13d                	beqz	a0,bf2 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b8e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b90:	4798                	lw	a4,8(a5)
 b92:	02977463          	bgeu	a4,s1,bba <malloc+0xbe>
    if(p == freep)
 b96:	00093703          	ld	a4,0(s2)
 b9a:	853e                	mv	a0,a5
 b9c:	fef719e3          	bne	a4,a5,b8e <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 ba0:	8552                	mv	a0,s4
 ba2:	00000097          	auipc	ra,0x0
 ba6:	b54080e7          	jalr	-1196(ra) # 6f6 <sbrk>
  if(p == (char*)-1)
 baa:	fd5518e3          	bne	a0,s5,b7a <malloc+0x7e>
        return 0;
 bae:	4501                	li	a0,0
 bb0:	7902                	ld	s2,32(sp)
 bb2:	6a42                	ld	s4,16(sp)
 bb4:	6aa2                	ld	s5,8(sp)
 bb6:	6b02                	ld	s6,0(sp)
 bb8:	a03d                	j	be6 <malloc+0xea>
 bba:	7902                	ld	s2,32(sp)
 bbc:	6a42                	ld	s4,16(sp)
 bbe:	6aa2                	ld	s5,8(sp)
 bc0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 bc2:	fae489e3          	beq	s1,a4,b74 <malloc+0x78>
        p->s.size -= nunits;
 bc6:	4137073b          	subw	a4,a4,s3
 bca:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bcc:	02071693          	slli	a3,a4,0x20
 bd0:	01c6d713          	srli	a4,a3,0x1c
 bd4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bd6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bda:	00000717          	auipc	a4,0x0
 bde:	42a73b23          	sd	a0,1078(a4) # 1010 <freep>
      return (void*)(p + 1);
 be2:	01078513          	addi	a0,a5,16
  }
}
 be6:	70e2                	ld	ra,56(sp)
 be8:	7442                	ld	s0,48(sp)
 bea:	74a2                	ld	s1,40(sp)
 bec:	69e2                	ld	s3,24(sp)
 bee:	6121                	addi	sp,sp,64
 bf0:	8082                	ret
 bf2:	7902                	ld	s2,32(sp)
 bf4:	6a42                	ld	s4,16(sp)
 bf6:	6aa2                	ld	s5,8(sp)
 bf8:	6b02                	ld	s6,0(sp)
 bfa:	b7f5                	j	be6 <malloc+0xea>

0000000000000bfc <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 bfc:	1141                	addi	sp,sp,-16
 bfe:	e406                	sd	ra,8(sp)
 c00:	e022                	sd	s0,0(sp)
 c02:	0800                	addi	s0,sp,16
  thread_exit(status);
 c04:	2501                	sext.w	a0,a0
 c06:	00000097          	auipc	ra,0x0
 c0a:	b20080e7          	jalr	-1248(ra) # 726 <thread_exit>
}
 c0e:	60a2                	ld	ra,8(sp)
 c10:	6402                	ld	s0,0(sp)
 c12:	0141                	addi	sp,sp,16
 c14:	8082                	ret

0000000000000c16 <free_stacks>:
int free_stacks() {
 c16:	7179                	addi	sp,sp,-48
 c18:	f406                	sd	ra,40(sp)
 c1a:	f022                	sd	s0,32(sp)
 c1c:	ec26                	sd	s1,24(sp)
 c1e:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 c20:	00000797          	auipc	a5,0x0
 c24:	4007a783          	lw	a5,1024(a5) # 1020 <num_threads>
 c28:	04f05063          	blez	a5,c68 <free_stacks+0x52>
 c2c:	e84a                	sd	s2,16(sp)
 c2e:	e44e                	sd	s3,8(sp)
 c30:	4481                	li	s1,0
    free(stacks[i]);
 c32:	00000997          	auipc	s3,0x0
 c36:	3e698993          	addi	s3,s3,998 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 c3a:	00000917          	auipc	s2,0x0
 c3e:	3e690913          	addi	s2,s2,998 # 1020 <num_threads>
    free(stacks[i]);
 c42:	0009b783          	ld	a5,0(s3)
 c46:	00349713          	slli	a4,s1,0x3
 c4a:	97ba                	add	a5,a5,a4
 c4c:	6388                	ld	a0,0(a5)
 c4e:	00000097          	auipc	ra,0x0
 c52:	e2c080e7          	jalr	-468(ra) # a7a <free>
  for (int i = 0; i < num_threads; i++) {
 c56:	0485                	addi	s1,s1,1
 c58:	00092703          	lw	a4,0(s2)
 c5c:	0004879b          	sext.w	a5,s1
 c60:	fee7c1e3          	blt	a5,a4,c42 <free_stacks+0x2c>
 c64:	6942                	ld	s2,16(sp)
 c66:	69a2                	ld	s3,8(sp)
  free(stacks);
 c68:	00000497          	auipc	s1,0x0
 c6c:	3b048493          	addi	s1,s1,944 # 1018 <stacks>
 c70:	6088                	ld	a0,0(s1)
 c72:	00000097          	auipc	ra,0x0
 c76:	e08080e7          	jalr	-504(ra) # a7a <free>
  stacks = 0;
 c7a:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 c7e:	00000797          	auipc	a5,0x0
 c82:	3a07a123          	sw	zero,930(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 c86:	47a1                	li	a5,8
 c88:	00000717          	auipc	a4,0x0
 c8c:	36f72c23          	sw	a5,888(a4) # 1000 <max_stacks>
  threads_done = 0;
 c90:	00000797          	auipc	a5,0x0
 c94:	3807aa23          	sw	zero,916(a5) # 1024 <threads_done>
}
 c98:	4501                	li	a0,0
 c9a:	70a2                	ld	ra,40(sp)
 c9c:	7402                	ld	s0,32(sp)
 c9e:	64e2                	ld	s1,24(sp)
 ca0:	6145                	addi	sp,sp,48
 ca2:	8082                	ret

0000000000000ca4 <expand_num_threads>:
int expand_num_threads() {
 ca4:	1101                	addi	sp,sp,-32
 ca6:	ec06                	sd	ra,24(sp)
 ca8:	e822                	sd	s0,16(sp)
 caa:	e426                	sd	s1,8(sp)
 cac:	e04a                	sd	s2,0(sp)
 cae:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 cb0:	00000797          	auipc	a5,0x0
 cb4:	35078793          	addi	a5,a5,848 # 1000 <max_stacks>
 cb8:	4388                	lw	a0,0(a5)
 cba:	0015151b          	slliw	a0,a0,0x1
 cbe:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 cc0:	0035151b          	slliw	a0,a0,0x3
 cc4:	00000097          	auipc	ra,0x0
 cc8:	e38080e7          	jalr	-456(ra) # afc <malloc>
 ccc:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 cce:	00000617          	auipc	a2,0x0
 cd2:	35262603          	lw	a2,850(a2) # 1020 <num_threads>
 cd6:	00000497          	auipc	s1,0x0
 cda:	34248493          	addi	s1,s1,834 # 1018 <stacks>
 cde:	0036161b          	slliw	a2,a2,0x3
 ce2:	608c                	ld	a1,0(s1)
 ce4:	00000097          	auipc	ra,0x0
 ce8:	840080e7          	jalr	-1984(ra) # 524 <memmove>
  free(stacks);
 cec:	6088                	ld	a0,0(s1)
 cee:	00000097          	auipc	ra,0x0
 cf2:	d8c080e7          	jalr	-628(ra) # a7a <free>
  stacks = new_stacks;
 cf6:	0124b023          	sd	s2,0(s1)
}
 cfa:	4501                	li	a0,0
 cfc:	60e2                	ld	ra,24(sp)
 cfe:	6442                	ld	s0,16(sp)
 d00:	64a2                	ld	s1,8(sp)
 d02:	6902                	ld	s2,0(sp)
 d04:	6105                	addi	sp,sp,32
 d06:	8082                	ret

0000000000000d08 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 d08:	7179                	addi	sp,sp,-48
 d0a:	f406                	sd	ra,40(sp)
 d0c:	f022                	sd	s0,32(sp)
 d0e:	e84a                	sd	s2,16(sp)
 d10:	e44e                	sd	s3,8(sp)
 d12:	1800                	addi	s0,sp,48
 d14:	892a                	mv	s2,a0
 d16:	89ae                	mv	s3,a1
  if (stacks == 0) {
 d18:	00000797          	auipc	a5,0x0
 d1c:	3007b783          	ld	a5,768(a5) # 1018 <stacks>
 d20:	c3d9                	beqz	a5,da6 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 d22:	00000797          	auipc	a5,0x0
 d26:	2de7a783          	lw	a5,734(a5) # 1000 <max_stacks>
 d2a:	00000717          	auipc	a4,0x0
 d2e:	2f672703          	lw	a4,758(a4) # 1020 <num_threads>
 d32:	0af71363          	bne	a4,a5,dd8 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 d36:	04000713          	li	a4,64
 d3a:	08e78563          	beq	a5,a4,dc4 <ithread_create+0xbc>
 d3e:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 d40:	00000097          	auipc	ra,0x0
 d44:	f64080e7          	jalr	-156(ra) # ca4 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 d48:	6505                	lui	a0,0x1
 d4a:	00000097          	auipc	ra,0x0
 d4e:	db2080e7          	jalr	-590(ra) # afc <malloc>
 d52:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 d54:	00000717          	auipc	a4,0x0
 d58:	2cc72703          	lw	a4,716(a4) # 1020 <num_threads>
 d5c:	070e                	slli	a4,a4,0x3
 d5e:	00000797          	auipc	a5,0x0
 d62:	2ba7b783          	ld	a5,698(a5) # 1018 <stacks>
 d66:	97ba                	add	a5,a5,a4
 d68:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 d6a:	00000697          	auipc	a3,0x0
 d6e:	e9268693          	addi	a3,a3,-366 # bfc <ithread_exit>
 d72:	862a                	mv	a2,a0
 d74:	85ce                	mv	a1,s3
 d76:	854a                	mv	a0,s2
 d78:	00000097          	auipc	ra,0x0
 d7c:	99e080e7          	jalr	-1634(ra) # 716 <create_thread>
 d80:	892a                	mv	s2,a0
  if (res != -1) {
 d82:	57fd                	li	a5,-1
 d84:	04f50c63          	beq	a0,a5,ddc <ithread_create+0xd4>
    num_threads++;
 d88:	00000717          	auipc	a4,0x0
 d8c:	29870713          	addi	a4,a4,664 # 1020 <num_threads>
 d90:	431c                	lw	a5,0(a4)
 d92:	2785                	addiw	a5,a5,1
 d94:	c31c                	sw	a5,0(a4)
 d96:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 d98:	854a                	mv	a0,s2
 d9a:	70a2                	ld	ra,40(sp)
 d9c:	7402                	ld	s0,32(sp)
 d9e:	6942                	ld	s2,16(sp)
 da0:	69a2                	ld	s3,8(sp)
 da2:	6145                	addi	sp,sp,48
 da4:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 da6:	00000517          	auipc	a0,0x0
 daa:	25a52503          	lw	a0,602(a0) # 1000 <max_stacks>
 dae:	0035151b          	slliw	a0,a0,0x3
 db2:	00000097          	auipc	ra,0x0
 db6:	d4a080e7          	jalr	-694(ra) # afc <malloc>
 dba:	00000797          	auipc	a5,0x0
 dbe:	24a7bf23          	sd	a0,606(a5) # 1018 <stacks>
 dc2:	b785                	j	d22 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 dc4:	00000517          	auipc	a0,0x0
 dc8:	10450513          	addi	a0,a0,260 # ec8 <ithread_join+0xc6>
 dcc:	00000097          	auipc	ra,0x0
 dd0:	c78080e7          	jalr	-904(ra) # a44 <printf>
      return -1;
 dd4:	597d                	li	s2,-1
 dd6:	b7c9                	j	d98 <ithread_create+0x90>
 dd8:	ec26                	sd	s1,24(sp)
 dda:	b7bd                	j	d48 <ithread_create+0x40>
    free(stack_ptr);
 ddc:	8526                	mv	a0,s1
 dde:	00000097          	auipc	ra,0x0
 de2:	c9c080e7          	jalr	-868(ra) # a7a <free>
    stacks[num_threads] = 0;
 de6:	00000717          	auipc	a4,0x0
 dea:	23a72703          	lw	a4,570(a4) # 1020 <num_threads>
 dee:	070e                	slli	a4,a4,0x3
 df0:	00000797          	auipc	a5,0x0
 df4:	2287b783          	ld	a5,552(a5) # 1018 <stacks>
 df8:	97ba                	add	a5,a5,a4
 dfa:	0007b023          	sd	zero,0(a5)
 dfe:	64e2                	ld	s1,24(sp)
 e00:	bf61                	j	d98 <ithread_create+0x90>

0000000000000e02 <ithread_join>:

int ithread_join(int thread_id) {
 e02:	1101                	addi	sp,sp,-32
 e04:	ec06                	sd	ra,24(sp)
 e06:	e822                	sd	s0,16(sp)
 e08:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 e0a:	ff040793          	addi	a5,s0,-16
 e0e:	ffc7859b          	addiw	a1,a5,-4
 e12:	00000097          	auipc	ra,0x0
 e16:	90c080e7          	jalr	-1780(ra) # 71e <join_thread>
  threads_done++;
 e1a:	00000717          	auipc	a4,0x0
 e1e:	20a70713          	addi	a4,a4,522 # 1024 <threads_done>
 e22:	431c                	lw	a5,0(a4)
 e24:	2785                	addiw	a5,a5,1
 e26:	0007869b          	sext.w	a3,a5
 e2a:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 e2c:	00000797          	auipc	a5,0x0
 e30:	1f47a783          	lw	a5,500(a5) # 1020 <num_threads>
 e34:	00d78863          	beq	a5,a3,e44 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 e38:	fec42503          	lw	a0,-20(s0)
 e3c:	60e2                	ld	ra,24(sp)
 e3e:	6442                	ld	s0,16(sp)
 e40:	6105                	addi	sp,sp,32
 e42:	8082                	ret
    free_stacks();
 e44:	00000097          	auipc	ra,0x0
 e48:	dd2080e7          	jalr	-558(ra) # c16 <free_stacks>
 e4c:	b7f5                	j	e38 <ithread_join+0x36>
