
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
  76:	43e080e7          	jalr	1086(ra) # 4b0 <memmove>
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
  ce:	4d8080e7          	jalr	1240(ra) # 5a2 <open>
  d2:	06054b63          	bltz	a0,148 <ls+0x94>
  d6:	24913c23          	sd	s1,600(sp)
  da:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  dc:	d9840593          	addi	a1,s0,-616
  e0:	00000097          	auipc	ra,0x0
  e4:	4da080e7          	jalr	1242(ra) # 5ba <fstat>
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
 11c:	c6850513          	addi	a0,a0,-920 # d80 <ithread_join+0x8a>
 120:	00001097          	auipc	ra,0x1
 124:	818080e7          	jalr	-2024(ra) # 938 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 128:	8526                	mv	a0,s1
 12a:	00000097          	auipc	ra,0x0
 12e:	460080e7          	jalr	1120(ra) # 58a <close>
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
 14e:	c0658593          	addi	a1,a1,-1018 # d50 <ithread_join+0x5a>
 152:	4509                	li	a0,2
 154:	00000097          	auipc	ra,0x0
 158:	7b6080e7          	jalr	1974(ra) # 90a <fprintf>
    return;
 15c:	bfe9                	j	136 <ls+0x82>
    fprintf(2, "ls: cannot stat %s\n", path);
 15e:	864a                	mv	a2,s2
 160:	00001597          	auipc	a1,0x1
 164:	c0858593          	addi	a1,a1,-1016 # d68 <ithread_join+0x72>
 168:	4509                	li	a0,2
 16a:	00000097          	auipc	ra,0x0
 16e:	7a0080e7          	jalr	1952(ra) # 90a <fprintf>
    close(fd);
 172:	8526                	mv	a0,s1
 174:	00000097          	auipc	ra,0x0
 178:	416080e7          	jalr	1046(ra) # 58a <close>
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
 19a:	bfa50513          	addi	a0,a0,-1030 # d90 <ithread_join+0x9a>
 19e:	00000097          	auipc	ra,0x0
 1a2:	79a080e7          	jalr	1946(ra) # 938 <printf>
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
 1ea:	bc2a0a13          	addi	s4,s4,-1086 # da8 <ithread_join+0xb2>
        printf("ls: cannot stat %s\n", buf);
 1ee:	00001a97          	auipc	s5,0x1
 1f2:	b7aa8a93          	addi	s5,s5,-1158 # d68 <ithread_join+0x72>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f6:	a801                	j	206 <ls+0x152>
        printf("ls: cannot stat %s\n", buf);
 1f8:	dc040593          	addi	a1,s0,-576
 1fc:	8556                	mv	a0,s5
 1fe:	00000097          	auipc	ra,0x0
 202:	73a080e7          	jalr	1850(ra) # 938 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 206:	4641                	li	a2,16
 208:	db040593          	addi	a1,s0,-592
 20c:	8526                	mv	a0,s1
 20e:	00000097          	auipc	ra,0x0
 212:	36c080e7          	jalr	876(ra) # 57a <read>
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
 22e:	286080e7          	jalr	646(ra) # 4b0 <memmove>
      p[DIRSIZ] = 0;
 232:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 236:	d9840593          	addi	a1,s0,-616
 23a:	dc040513          	addi	a0,s0,-576
 23e:	00000097          	auipc	ra,0x0
 242:	1e4080e7          	jalr	484(ra) # 422 <stat>
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
 26a:	6d2080e7          	jalr	1746(ra) # 938 <printf>
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
 2ba:	2ac080e7          	jalr	684(ra) # 562 <exit>
 2be:	e426                	sd	s1,8(sp)
 2c0:	e04a                	sd	s2,0(sp)
    ls(".");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	af650513          	addi	a0,a0,-1290 # db8 <ithread_join+0xc2>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	dea080e7          	jalr	-534(ra) # b4 <ls>
    exit(0);
 2d2:	4501                	li	a0,0
 2d4:	00000097          	auipc	ra,0x0
 2d8:	28e080e7          	jalr	654(ra) # 562 <exit>

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
 2f2:	274080e7          	jalr	628(ra) # 562 <exit>

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
 3e4:	19a080e7          	jalr	410(ra) # 57a <read>
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

0000000000000422 <stat>:

int
stat(const char *n, struct stat *st)
{
 422:	1101                	addi	sp,sp,-32
 424:	ec06                	sd	ra,24(sp)
 426:	e822                	sd	s0,16(sp)
 428:	e04a                	sd	s2,0(sp)
 42a:	1000                	addi	s0,sp,32
 42c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 42e:	4581                	li	a1,0
 430:	00000097          	auipc	ra,0x0
 434:	172080e7          	jalr	370(ra) # 5a2 <open>
  if(fd < 0)
 438:	02054663          	bltz	a0,464 <stat+0x42>
 43c:	e426                	sd	s1,8(sp)
 43e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 440:	85ca                	mv	a1,s2
 442:	00000097          	auipc	ra,0x0
 446:	178080e7          	jalr	376(ra) # 5ba <fstat>
 44a:	892a                	mv	s2,a0
  close(fd);
 44c:	8526                	mv	a0,s1
 44e:	00000097          	auipc	ra,0x0
 452:	13c080e7          	jalr	316(ra) # 58a <close>
  return r;
 456:	64a2                	ld	s1,8(sp)
}
 458:	854a                	mv	a0,s2
 45a:	60e2                	ld	ra,24(sp)
 45c:	6442                	ld	s0,16(sp)
 45e:	6902                	ld	s2,0(sp)
 460:	6105                	addi	sp,sp,32
 462:	8082                	ret
    return -1;
 464:	597d                	li	s2,-1
 466:	bfcd                	j	458 <stat+0x36>

0000000000000468 <atoi>:

int
atoi(const char *s)
{
 468:	1141                	addi	sp,sp,-16
 46a:	e422                	sd	s0,8(sp)
 46c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 46e:	00054683          	lbu	a3,0(a0)
 472:	fd06879b          	addiw	a5,a3,-48
 476:	0ff7f793          	zext.b	a5,a5
 47a:	4625                	li	a2,9
 47c:	02f66863          	bltu	a2,a5,4ac <atoi+0x44>
 480:	872a                	mv	a4,a0
  n = 0;
 482:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 484:	0705                	addi	a4,a4,1
 486:	0025179b          	slliw	a5,a0,0x2
 48a:	9fa9                	addw	a5,a5,a0
 48c:	0017979b          	slliw	a5,a5,0x1
 490:	9fb5                	addw	a5,a5,a3
 492:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 496:	00074683          	lbu	a3,0(a4)
 49a:	fd06879b          	addiw	a5,a3,-48
 49e:	0ff7f793          	zext.b	a5,a5
 4a2:	fef671e3          	bgeu	a2,a5,484 <atoi+0x1c>
  return n;
}
 4a6:	6422                	ld	s0,8(sp)
 4a8:	0141                	addi	sp,sp,16
 4aa:	8082                	ret
  n = 0;
 4ac:	4501                	li	a0,0
 4ae:	bfe5                	j	4a6 <atoi+0x3e>

00000000000004b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e422                	sd	s0,8(sp)
 4b4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4b6:	02b57463          	bgeu	a0,a1,4de <memmove+0x2e>
    while(n-- > 0)
 4ba:	00c05f63          	blez	a2,4d8 <memmove+0x28>
 4be:	1602                	slli	a2,a2,0x20
 4c0:	9201                	srli	a2,a2,0x20
 4c2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4c6:	872a                	mv	a4,a0
      *dst++ = *src++;
 4c8:	0585                	addi	a1,a1,1
 4ca:	0705                	addi	a4,a4,1
 4cc:	fff5c683          	lbu	a3,-1(a1)
 4d0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4d4:	fef71ae3          	bne	a4,a5,4c8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4d8:	6422                	ld	s0,8(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret
    dst += n;
 4de:	00c50733          	add	a4,a0,a2
    src += n;
 4e2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4e4:	fec05ae3          	blez	a2,4d8 <memmove+0x28>
 4e8:	fff6079b          	addiw	a5,a2,-1
 4ec:	1782                	slli	a5,a5,0x20
 4ee:	9381                	srli	a5,a5,0x20
 4f0:	fff7c793          	not	a5,a5
 4f4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4f6:	15fd                	addi	a1,a1,-1
 4f8:	177d                	addi	a4,a4,-1
 4fa:	0005c683          	lbu	a3,0(a1)
 4fe:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 502:	fee79ae3          	bne	a5,a4,4f6 <memmove+0x46>
 506:	bfc9                	j	4d8 <memmove+0x28>

0000000000000508 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 508:	1141                	addi	sp,sp,-16
 50a:	e422                	sd	s0,8(sp)
 50c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 50e:	ca05                	beqz	a2,53e <memcmp+0x36>
 510:	fff6069b          	addiw	a3,a2,-1
 514:	1682                	slli	a3,a3,0x20
 516:	9281                	srli	a3,a3,0x20
 518:	0685                	addi	a3,a3,1
 51a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 51c:	00054783          	lbu	a5,0(a0)
 520:	0005c703          	lbu	a4,0(a1)
 524:	00e79863          	bne	a5,a4,534 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 528:	0505                	addi	a0,a0,1
    p2++;
 52a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 52c:	fed518e3          	bne	a0,a3,51c <memcmp+0x14>
  }
  return 0;
 530:	4501                	li	a0,0
 532:	a019                	j	538 <memcmp+0x30>
      return *p1 - *p2;
 534:	40e7853b          	subw	a0,a5,a4
}
 538:	6422                	ld	s0,8(sp)
 53a:	0141                	addi	sp,sp,16
 53c:	8082                	ret
  return 0;
 53e:	4501                	li	a0,0
 540:	bfe5                	j	538 <memcmp+0x30>

0000000000000542 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 542:	1141                	addi	sp,sp,-16
 544:	e406                	sd	ra,8(sp)
 546:	e022                	sd	s0,0(sp)
 548:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 54a:	00000097          	auipc	ra,0x0
 54e:	f66080e7          	jalr	-154(ra) # 4b0 <memmove>
}
 552:	60a2                	ld	ra,8(sp)
 554:	6402                	ld	s0,0(sp)
 556:	0141                	addi	sp,sp,16
 558:	8082                	ret

000000000000055a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 55a:	4885                	li	a7,1
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <exit>:
.global exit
exit:
 li a7, SYS_exit
 562:	4889                	li	a7,2
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <wait>:
.global wait
wait:
 li a7, SYS_wait
 56a:	488d                	li	a7,3
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 572:	4891                	li	a7,4
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <read>:
.global read
read:
 li a7, SYS_read
 57a:	4895                	li	a7,5
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <write>:
.global write
write:
 li a7, SYS_write
 582:	48c1                	li	a7,16
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <close>:
.global close
close:
 li a7, SYS_close
 58a:	48d5                	li	a7,21
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <kill>:
.global kill
kill:
 li a7, SYS_kill
 592:	4899                	li	a7,6
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <exec>:
.global exec
exec:
 li a7, SYS_exec
 59a:	489d                	li	a7,7
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <open>:
.global open
open:
 li a7, SYS_open
 5a2:	48bd                	li	a7,15
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5aa:	48c5                	li	a7,17
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5b2:	48c9                	li	a7,18
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ba:	48a1                	li	a7,8
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <link>:
.global link
link:
 li a7, SYS_link
 5c2:	48cd                	li	a7,19
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ca:	48d1                	li	a7,20
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5d2:	48a5                	li	a7,9
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <dup>:
.global dup
dup:
 li a7, SYS_dup
 5da:	48a9                	li	a7,10
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5e2:	48ad                	li	a7,11
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5ea:	48b1                	li	a7,12
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5f2:	48b5                	li	a7,13
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5fa:	48b9                	li	a7,14
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 602:	48d9                	li	a7,22
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 60a:	48dd                	li	a7,23
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 612:	48e1                	li	a7,24
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 61a:	48e5                	li	a7,25
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <socket>:
.global socket
socket:
 li a7, SYS_socket
 622:	48e9                	li	a7,26
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <bind>:
.global bind
bind:
 li a7, SYS_bind
 62a:	48ed                	li	a7,27
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <accept>:
.global accept
accept:
 li a7, SYS_accept
 632:	48f5                	li	a7,29
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <listen>:
.global listen
listen:
 li a7, SYS_listen
 63a:	48f1                	li	a7,28
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <connect>:
.global connect
connect:
 li a7, SYS_connect
 642:	48f9                	li	a7,30
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <send>:
.global send
send:
 li a7, SYS_send
 64a:	48fd                	li	a7,31
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <recv>:
.global recv
recv:
 li a7, SYS_recv
 652:	02000893          	li	a7,32
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 65c:	02100893          	li	a7,33
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 666:	02200893          	li	a7,34
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 670:	1101                	addi	sp,sp,-32
 672:	ec06                	sd	ra,24(sp)
 674:	e822                	sd	s0,16(sp)
 676:	1000                	addi	s0,sp,32
 678:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 67c:	4605                	li	a2,1
 67e:	fef40593          	addi	a1,s0,-17
 682:	00000097          	auipc	ra,0x0
 686:	f00080e7          	jalr	-256(ra) # 582 <write>
}
 68a:	60e2                	ld	ra,24(sp)
 68c:	6442                	ld	s0,16(sp)
 68e:	6105                	addi	sp,sp,32
 690:	8082                	ret

0000000000000692 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 692:	7139                	addi	sp,sp,-64
 694:	fc06                	sd	ra,56(sp)
 696:	f822                	sd	s0,48(sp)
 698:	f426                	sd	s1,40(sp)
 69a:	0080                	addi	s0,sp,64
 69c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 69e:	c299                	beqz	a3,6a4 <printint+0x12>
 6a0:	0805cb63          	bltz	a1,736 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6a4:	2581                	sext.w	a1,a1
  neg = 0;
 6a6:	4881                	li	a7,0
 6a8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6ac:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6ae:	2601                	sext.w	a2,a2
 6b0:	00000517          	auipc	a0,0x0
 6b4:	7a050513          	addi	a0,a0,1952 # e50 <digits>
 6b8:	883a                	mv	a6,a4
 6ba:	2705                	addiw	a4,a4,1
 6bc:	02c5f7bb          	remuw	a5,a1,a2
 6c0:	1782                	slli	a5,a5,0x20
 6c2:	9381                	srli	a5,a5,0x20
 6c4:	97aa                	add	a5,a5,a0
 6c6:	0007c783          	lbu	a5,0(a5)
 6ca:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6ce:	0005879b          	sext.w	a5,a1
 6d2:	02c5d5bb          	divuw	a1,a1,a2
 6d6:	0685                	addi	a3,a3,1
 6d8:	fec7f0e3          	bgeu	a5,a2,6b8 <printint+0x26>
  if(neg)
 6dc:	00088c63          	beqz	a7,6f4 <printint+0x62>
    buf[i++] = '-';
 6e0:	fd070793          	addi	a5,a4,-48
 6e4:	00878733          	add	a4,a5,s0
 6e8:	02d00793          	li	a5,45
 6ec:	fef70823          	sb	a5,-16(a4)
 6f0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6f4:	02e05c63          	blez	a4,72c <printint+0x9a>
 6f8:	f04a                	sd	s2,32(sp)
 6fa:	ec4e                	sd	s3,24(sp)
 6fc:	fc040793          	addi	a5,s0,-64
 700:	00e78933          	add	s2,a5,a4
 704:	fff78993          	addi	s3,a5,-1
 708:	99ba                	add	s3,s3,a4
 70a:	377d                	addiw	a4,a4,-1
 70c:	1702                	slli	a4,a4,0x20
 70e:	9301                	srli	a4,a4,0x20
 710:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 714:	fff94583          	lbu	a1,-1(s2)
 718:	8526                	mv	a0,s1
 71a:	00000097          	auipc	ra,0x0
 71e:	f56080e7          	jalr	-170(ra) # 670 <putc>
  while(--i >= 0)
 722:	197d                	addi	s2,s2,-1
 724:	ff3918e3          	bne	s2,s3,714 <printint+0x82>
 728:	7902                	ld	s2,32(sp)
 72a:	69e2                	ld	s3,24(sp)
}
 72c:	70e2                	ld	ra,56(sp)
 72e:	7442                	ld	s0,48(sp)
 730:	74a2                	ld	s1,40(sp)
 732:	6121                	addi	sp,sp,64
 734:	8082                	ret
    x = -xx;
 736:	40b005bb          	negw	a1,a1
    neg = 1;
 73a:	4885                	li	a7,1
    x = -xx;
 73c:	b7b5                	j	6a8 <printint+0x16>

000000000000073e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 73e:	715d                	addi	sp,sp,-80
 740:	e486                	sd	ra,72(sp)
 742:	e0a2                	sd	s0,64(sp)
 744:	f84a                	sd	s2,48(sp)
 746:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 748:	0005c903          	lbu	s2,0(a1)
 74c:	1a090a63          	beqz	s2,900 <vprintf+0x1c2>
 750:	fc26                	sd	s1,56(sp)
 752:	f44e                	sd	s3,40(sp)
 754:	f052                	sd	s4,32(sp)
 756:	ec56                	sd	s5,24(sp)
 758:	e85a                	sd	s6,16(sp)
 75a:	e45e                	sd	s7,8(sp)
 75c:	8aaa                	mv	s5,a0
 75e:	8bb2                	mv	s7,a2
 760:	00158493          	addi	s1,a1,1
  state = 0;
 764:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 766:	02500a13          	li	s4,37
 76a:	4b55                	li	s6,21
 76c:	a839                	j	78a <vprintf+0x4c>
        putc(fd, c);
 76e:	85ca                	mv	a1,s2
 770:	8556                	mv	a0,s5
 772:	00000097          	auipc	ra,0x0
 776:	efe080e7          	jalr	-258(ra) # 670 <putc>
 77a:	a019                	j	780 <vprintf+0x42>
    } else if(state == '%'){
 77c:	01498d63          	beq	s3,s4,796 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 780:	0485                	addi	s1,s1,1
 782:	fff4c903          	lbu	s2,-1(s1)
 786:	16090763          	beqz	s2,8f4 <vprintf+0x1b6>
    if(state == 0){
 78a:	fe0999e3          	bnez	s3,77c <vprintf+0x3e>
      if(c == '%'){
 78e:	ff4910e3          	bne	s2,s4,76e <vprintf+0x30>
        state = '%';
 792:	89d2                	mv	s3,s4
 794:	b7f5                	j	780 <vprintf+0x42>
      if(c == 'd'){
 796:	13490463          	beq	s2,s4,8be <vprintf+0x180>
 79a:	f9d9079b          	addiw	a5,s2,-99
 79e:	0ff7f793          	zext.b	a5,a5
 7a2:	12fb6763          	bltu	s6,a5,8d0 <vprintf+0x192>
 7a6:	f9d9079b          	addiw	a5,s2,-99
 7aa:	0ff7f713          	zext.b	a4,a5
 7ae:	12eb6163          	bltu	s6,a4,8d0 <vprintf+0x192>
 7b2:	00271793          	slli	a5,a4,0x2
 7b6:	00000717          	auipc	a4,0x0
 7ba:	64270713          	addi	a4,a4,1602 # df8 <ithread_join+0x102>
 7be:	97ba                	add	a5,a5,a4
 7c0:	439c                	lw	a5,0(a5)
 7c2:	97ba                	add	a5,a5,a4
 7c4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7c6:	008b8913          	addi	s2,s7,8
 7ca:	4685                	li	a3,1
 7cc:	4629                	li	a2,10
 7ce:	000ba583          	lw	a1,0(s7)
 7d2:	8556                	mv	a0,s5
 7d4:	00000097          	auipc	ra,0x0
 7d8:	ebe080e7          	jalr	-322(ra) # 692 <printint>
 7dc:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b745                	j	780 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e2:	008b8913          	addi	s2,s7,8
 7e6:	4681                	li	a3,0
 7e8:	4629                	li	a2,10
 7ea:	000ba583          	lw	a1,0(s7)
 7ee:	8556                	mv	a0,s5
 7f0:	00000097          	auipc	ra,0x0
 7f4:	ea2080e7          	jalr	-350(ra) # 692 <printint>
 7f8:	8bca                	mv	s7,s2
      state = 0;
 7fa:	4981                	li	s3,0
 7fc:	b751                	j	780 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7fe:	008b8913          	addi	s2,s7,8
 802:	4681                	li	a3,0
 804:	4641                	li	a2,16
 806:	000ba583          	lw	a1,0(s7)
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	e86080e7          	jalr	-378(ra) # 692 <printint>
 814:	8bca                	mv	s7,s2
      state = 0;
 816:	4981                	li	s3,0
 818:	b7a5                	j	780 <vprintf+0x42>
 81a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 81c:	008b8c13          	addi	s8,s7,8
 820:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 824:	03000593          	li	a1,48
 828:	8556                	mv	a0,s5
 82a:	00000097          	auipc	ra,0x0
 82e:	e46080e7          	jalr	-442(ra) # 670 <putc>
  putc(fd, 'x');
 832:	07800593          	li	a1,120
 836:	8556                	mv	a0,s5
 838:	00000097          	auipc	ra,0x0
 83c:	e38080e7          	jalr	-456(ra) # 670 <putc>
 840:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 842:	00000b97          	auipc	s7,0x0
 846:	60eb8b93          	addi	s7,s7,1550 # e50 <digits>
 84a:	03c9d793          	srli	a5,s3,0x3c
 84e:	97de                	add	a5,a5,s7
 850:	0007c583          	lbu	a1,0(a5)
 854:	8556                	mv	a0,s5
 856:	00000097          	auipc	ra,0x0
 85a:	e1a080e7          	jalr	-486(ra) # 670 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 85e:	0992                	slli	s3,s3,0x4
 860:	397d                	addiw	s2,s2,-1
 862:	fe0914e3          	bnez	s2,84a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 866:	8be2                	mv	s7,s8
      state = 0;
 868:	4981                	li	s3,0
 86a:	6c02                	ld	s8,0(sp)
 86c:	bf11                	j	780 <vprintf+0x42>
        s = va_arg(ap, char*);
 86e:	008b8993          	addi	s3,s7,8
 872:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 876:	02090163          	beqz	s2,898 <vprintf+0x15a>
        while(*s != 0){
 87a:	00094583          	lbu	a1,0(s2)
 87e:	c9a5                	beqz	a1,8ee <vprintf+0x1b0>
          putc(fd, *s);
 880:	8556                	mv	a0,s5
 882:	00000097          	auipc	ra,0x0
 886:	dee080e7          	jalr	-530(ra) # 670 <putc>
          s++;
 88a:	0905                	addi	s2,s2,1
        while(*s != 0){
 88c:	00094583          	lbu	a1,0(s2)
 890:	f9e5                	bnez	a1,880 <vprintf+0x142>
        s = va_arg(ap, char*);
 892:	8bce                	mv	s7,s3
      state = 0;
 894:	4981                	li	s3,0
 896:	b5ed                	j	780 <vprintf+0x42>
          s = "(null)";
 898:	00000917          	auipc	s2,0x0
 89c:	52890913          	addi	s2,s2,1320 # dc0 <ithread_join+0xca>
        while(*s != 0){
 8a0:	02800593          	li	a1,40
 8a4:	bff1                	j	880 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 8a6:	008b8913          	addi	s2,s7,8
 8aa:	000bc583          	lbu	a1,0(s7)
 8ae:	8556                	mv	a0,s5
 8b0:	00000097          	auipc	ra,0x0
 8b4:	dc0080e7          	jalr	-576(ra) # 670 <putc>
 8b8:	8bca                	mv	s7,s2
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	b5d1                	j	780 <vprintf+0x42>
        putc(fd, c);
 8be:	02500593          	li	a1,37
 8c2:	8556                	mv	a0,s5
 8c4:	00000097          	auipc	ra,0x0
 8c8:	dac080e7          	jalr	-596(ra) # 670 <putc>
      state = 0;
 8cc:	4981                	li	s3,0
 8ce:	bd4d                	j	780 <vprintf+0x42>
        putc(fd, '%');
 8d0:	02500593          	li	a1,37
 8d4:	8556                	mv	a0,s5
 8d6:	00000097          	auipc	ra,0x0
 8da:	d9a080e7          	jalr	-614(ra) # 670 <putc>
        putc(fd, c);
 8de:	85ca                	mv	a1,s2
 8e0:	8556                	mv	a0,s5
 8e2:	00000097          	auipc	ra,0x0
 8e6:	d8e080e7          	jalr	-626(ra) # 670 <putc>
      state = 0;
 8ea:	4981                	li	s3,0
 8ec:	bd51                	j	780 <vprintf+0x42>
        s = va_arg(ap, char*);
 8ee:	8bce                	mv	s7,s3
      state = 0;
 8f0:	4981                	li	s3,0
 8f2:	b579                	j	780 <vprintf+0x42>
 8f4:	74e2                	ld	s1,56(sp)
 8f6:	79a2                	ld	s3,40(sp)
 8f8:	7a02                	ld	s4,32(sp)
 8fa:	6ae2                	ld	s5,24(sp)
 8fc:	6b42                	ld	s6,16(sp)
 8fe:	6ba2                	ld	s7,8(sp)
    }
  }
}
 900:	60a6                	ld	ra,72(sp)
 902:	6406                	ld	s0,64(sp)
 904:	7942                	ld	s2,48(sp)
 906:	6161                	addi	sp,sp,80
 908:	8082                	ret

000000000000090a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 90a:	715d                	addi	sp,sp,-80
 90c:	ec06                	sd	ra,24(sp)
 90e:	e822                	sd	s0,16(sp)
 910:	1000                	addi	s0,sp,32
 912:	e010                	sd	a2,0(s0)
 914:	e414                	sd	a3,8(s0)
 916:	e818                	sd	a4,16(s0)
 918:	ec1c                	sd	a5,24(s0)
 91a:	03043023          	sd	a6,32(s0)
 91e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 922:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 926:	8622                	mv	a2,s0
 928:	00000097          	auipc	ra,0x0
 92c:	e16080e7          	jalr	-490(ra) # 73e <vprintf>
}
 930:	60e2                	ld	ra,24(sp)
 932:	6442                	ld	s0,16(sp)
 934:	6161                	addi	sp,sp,80
 936:	8082                	ret

0000000000000938 <printf>:

void
printf(const char *fmt, ...)
{
 938:	711d                	addi	sp,sp,-96
 93a:	ec06                	sd	ra,24(sp)
 93c:	e822                	sd	s0,16(sp)
 93e:	1000                	addi	s0,sp,32
 940:	e40c                	sd	a1,8(s0)
 942:	e810                	sd	a2,16(s0)
 944:	ec14                	sd	a3,24(s0)
 946:	f018                	sd	a4,32(s0)
 948:	f41c                	sd	a5,40(s0)
 94a:	03043823          	sd	a6,48(s0)
 94e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 952:	00840613          	addi	a2,s0,8
 956:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 95a:	85aa                	mv	a1,a0
 95c:	4505                	li	a0,1
 95e:	00000097          	auipc	ra,0x0
 962:	de0080e7          	jalr	-544(ra) # 73e <vprintf>
}
 966:	60e2                	ld	ra,24(sp)
 968:	6442                	ld	s0,16(sp)
 96a:	6125                	addi	sp,sp,96
 96c:	8082                	ret

000000000000096e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 96e:	1141                	addi	sp,sp,-16
 970:	e422                	sd	s0,8(sp)
 972:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 974:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 978:	00000797          	auipc	a5,0x0
 97c:	6987b783          	ld	a5,1688(a5) # 1010 <freep>
 980:	a02d                	j	9aa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 982:	4618                	lw	a4,8(a2)
 984:	9f2d                	addw	a4,a4,a1
 986:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 98a:	6398                	ld	a4,0(a5)
 98c:	6310                	ld	a2,0(a4)
 98e:	a83d                	j	9cc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 990:	ff852703          	lw	a4,-8(a0)
 994:	9f31                	addw	a4,a4,a2
 996:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 998:	ff053683          	ld	a3,-16(a0)
 99c:	a091                	j	9e0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99e:	6398                	ld	a4,0(a5)
 9a0:	00e7e463          	bltu	a5,a4,9a8 <free+0x3a>
 9a4:	00e6ea63          	bltu	a3,a4,9b8 <free+0x4a>
{
 9a8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9aa:	fed7fae3          	bgeu	a5,a3,99e <free+0x30>
 9ae:	6398                	ld	a4,0(a5)
 9b0:	00e6e463          	bltu	a3,a4,9b8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b4:	fee7eae3          	bltu	a5,a4,9a8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9b8:	ff852583          	lw	a1,-8(a0)
 9bc:	6390                	ld	a2,0(a5)
 9be:	02059813          	slli	a6,a1,0x20
 9c2:	01c85713          	srli	a4,a6,0x1c
 9c6:	9736                	add	a4,a4,a3
 9c8:	fae60de3          	beq	a2,a4,982 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9cc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9d0:	4790                	lw	a2,8(a5)
 9d2:	02061593          	slli	a1,a2,0x20
 9d6:	01c5d713          	srli	a4,a1,0x1c
 9da:	973e                	add	a4,a4,a5
 9dc:	fae68ae3          	beq	a3,a4,990 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9e0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9e2:	00000717          	auipc	a4,0x0
 9e6:	62f73723          	sd	a5,1582(a4) # 1010 <freep>
}
 9ea:	6422                	ld	s0,8(sp)
 9ec:	0141                	addi	sp,sp,16
 9ee:	8082                	ret

00000000000009f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9f0:	7139                	addi	sp,sp,-64
 9f2:	fc06                	sd	ra,56(sp)
 9f4:	f822                	sd	s0,48(sp)
 9f6:	f426                	sd	s1,40(sp)
 9f8:	ec4e                	sd	s3,24(sp)
 9fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9fc:	02051493          	slli	s1,a0,0x20
 a00:	9081                	srli	s1,s1,0x20
 a02:	04bd                	addi	s1,s1,15
 a04:	8091                	srli	s1,s1,0x4
 a06:	0014899b          	addiw	s3,s1,1
 a0a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a0c:	00000517          	auipc	a0,0x0
 a10:	60453503          	ld	a0,1540(a0) # 1010 <freep>
 a14:	c915                	beqz	a0,a48 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a16:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a18:	4798                	lw	a4,8(a5)
 a1a:	08977e63          	bgeu	a4,s1,ab6 <malloc+0xc6>
 a1e:	f04a                	sd	s2,32(sp)
 a20:	e852                	sd	s4,16(sp)
 a22:	e456                	sd	s5,8(sp)
 a24:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a26:	8a4e                	mv	s4,s3
 a28:	0009871b          	sext.w	a4,s3
 a2c:	6685                	lui	a3,0x1
 a2e:	00d77363          	bgeu	a4,a3,a34 <malloc+0x44>
 a32:	6a05                	lui	s4,0x1
 a34:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a38:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a3c:	00000917          	auipc	s2,0x0
 a40:	5d490913          	addi	s2,s2,1492 # 1010 <freep>
  if(p == (char*)-1)
 a44:	5afd                	li	s5,-1
 a46:	a091                	j	a8a <malloc+0x9a>
 a48:	f04a                	sd	s2,32(sp)
 a4a:	e852                	sd	s4,16(sp)
 a4c:	e456                	sd	s5,8(sp)
 a4e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a50:	00000797          	auipc	a5,0x0
 a54:	5f078793          	addi	a5,a5,1520 # 1040 <base>
 a58:	00000717          	auipc	a4,0x0
 a5c:	5af73c23          	sd	a5,1464(a4) # 1010 <freep>
 a60:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a62:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a66:	b7c1                	j	a26 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a68:	6398                	ld	a4,0(a5)
 a6a:	e118                	sd	a4,0(a0)
 a6c:	a08d                	j	ace <malloc+0xde>
  hp->s.size = nu;
 a6e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a72:	0541                	addi	a0,a0,16
 a74:	00000097          	auipc	ra,0x0
 a78:	efa080e7          	jalr	-262(ra) # 96e <free>
  return freep;
 a7c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a80:	c13d                	beqz	a0,ae6 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a82:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a84:	4798                	lw	a4,8(a5)
 a86:	02977463          	bgeu	a4,s1,aae <malloc+0xbe>
    if(p == freep)
 a8a:	00093703          	ld	a4,0(s2)
 a8e:	853e                	mv	a0,a5
 a90:	fef719e3          	bne	a4,a5,a82 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a94:	8552                	mv	a0,s4
 a96:	00000097          	auipc	ra,0x0
 a9a:	b54080e7          	jalr	-1196(ra) # 5ea <sbrk>
  if(p == (char*)-1)
 a9e:	fd5518e3          	bne	a0,s5,a6e <malloc+0x7e>
        return 0;
 aa2:	4501                	li	a0,0
 aa4:	7902                	ld	s2,32(sp)
 aa6:	6a42                	ld	s4,16(sp)
 aa8:	6aa2                	ld	s5,8(sp)
 aaa:	6b02                	ld	s6,0(sp)
 aac:	a03d                	j	ada <malloc+0xea>
 aae:	7902                	ld	s2,32(sp)
 ab0:	6a42                	ld	s4,16(sp)
 ab2:	6aa2                	ld	s5,8(sp)
 ab4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ab6:	fae489e3          	beq	s1,a4,a68 <malloc+0x78>
        p->s.size -= nunits;
 aba:	4137073b          	subw	a4,a4,s3
 abe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ac0:	02071693          	slli	a3,a4,0x20
 ac4:	01c6d713          	srli	a4,a3,0x1c
 ac8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ace:	00000717          	auipc	a4,0x0
 ad2:	54a73123          	sd	a0,1346(a4) # 1010 <freep>
      return (void*)(p + 1);
 ad6:	01078513          	addi	a0,a5,16
  }
}
 ada:	70e2                	ld	ra,56(sp)
 adc:	7442                	ld	s0,48(sp)
 ade:	74a2                	ld	s1,40(sp)
 ae0:	69e2                	ld	s3,24(sp)
 ae2:	6121                	addi	sp,sp,64
 ae4:	8082                	ret
 ae6:	7902                	ld	s2,32(sp)
 ae8:	6a42                	ld	s4,16(sp)
 aea:	6aa2                	ld	s5,8(sp)
 aec:	6b02                	ld	s6,0(sp)
 aee:	b7f5                	j	ada <malloc+0xea>

0000000000000af0 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 af0:	1141                	addi	sp,sp,-16
 af2:	e406                	sd	ra,8(sp)
 af4:	e022                	sd	s0,0(sp)
 af6:	0800                	addi	s0,sp,16
  thread_exit(status);
 af8:	2501                	sext.w	a0,a0
 afa:	00000097          	auipc	ra,0x0
 afe:	b20080e7          	jalr	-1248(ra) # 61a <thread_exit>
}
 b02:	60a2                	ld	ra,8(sp)
 b04:	6402                	ld	s0,0(sp)
 b06:	0141                	addi	sp,sp,16
 b08:	8082                	ret

0000000000000b0a <free_stacks>:
int free_stacks() {
 b0a:	7179                	addi	sp,sp,-48
 b0c:	f406                	sd	ra,40(sp)
 b0e:	f022                	sd	s0,32(sp)
 b10:	ec26                	sd	s1,24(sp)
 b12:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 b14:	00000797          	auipc	a5,0x0
 b18:	50c7a783          	lw	a5,1292(a5) # 1020 <num_threads>
 b1c:	04f05063          	blez	a5,b5c <free_stacks+0x52>
 b20:	e84a                	sd	s2,16(sp)
 b22:	e44e                	sd	s3,8(sp)
 b24:	4481                	li	s1,0
    free(stacks[i]);
 b26:	00000997          	auipc	s3,0x0
 b2a:	4f298993          	addi	s3,s3,1266 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 b2e:	00000917          	auipc	s2,0x0
 b32:	4f290913          	addi	s2,s2,1266 # 1020 <num_threads>
    free(stacks[i]);
 b36:	0009b783          	ld	a5,0(s3)
 b3a:	00349713          	slli	a4,s1,0x3
 b3e:	97ba                	add	a5,a5,a4
 b40:	6388                	ld	a0,0(a5)
 b42:	00000097          	auipc	ra,0x0
 b46:	e2c080e7          	jalr	-468(ra) # 96e <free>
  for (int i = 0; i < num_threads; i++) {
 b4a:	0485                	addi	s1,s1,1
 b4c:	00092703          	lw	a4,0(s2)
 b50:	0004879b          	sext.w	a5,s1
 b54:	fee7c1e3          	blt	a5,a4,b36 <free_stacks+0x2c>
 b58:	6942                	ld	s2,16(sp)
 b5a:	69a2                	ld	s3,8(sp)
  free(stacks);
 b5c:	00000497          	auipc	s1,0x0
 b60:	4bc48493          	addi	s1,s1,1212 # 1018 <stacks>
 b64:	6088                	ld	a0,0(s1)
 b66:	00000097          	auipc	ra,0x0
 b6a:	e08080e7          	jalr	-504(ra) # 96e <free>
  stacks = 0;
 b6e:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 b72:	00000797          	auipc	a5,0x0
 b76:	4a07a723          	sw	zero,1198(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 b7a:	47a1                	li	a5,8
 b7c:	00000717          	auipc	a4,0x0
 b80:	48f72223          	sw	a5,1156(a4) # 1000 <max_stacks>
  threads_done = 0;
 b84:	00000797          	auipc	a5,0x0
 b88:	4a07a023          	sw	zero,1184(a5) # 1024 <threads_done>
}
 b8c:	4501                	li	a0,0
 b8e:	70a2                	ld	ra,40(sp)
 b90:	7402                	ld	s0,32(sp)
 b92:	64e2                	ld	s1,24(sp)
 b94:	6145                	addi	sp,sp,48
 b96:	8082                	ret

0000000000000b98 <expand_num_threads>:
int expand_num_threads() {
 b98:	1101                	addi	sp,sp,-32
 b9a:	ec06                	sd	ra,24(sp)
 b9c:	e822                	sd	s0,16(sp)
 b9e:	e426                	sd	s1,8(sp)
 ba0:	e04a                	sd	s2,0(sp)
 ba2:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 ba4:	00000797          	auipc	a5,0x0
 ba8:	45c78793          	addi	a5,a5,1116 # 1000 <max_stacks>
 bac:	4388                	lw	a0,0(a5)
 bae:	0015151b          	slliw	a0,a0,0x1
 bb2:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 bb4:	0035151b          	slliw	a0,a0,0x3
 bb8:	00000097          	auipc	ra,0x0
 bbc:	e38080e7          	jalr	-456(ra) # 9f0 <malloc>
 bc0:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 bc2:	00000617          	auipc	a2,0x0
 bc6:	45e62603          	lw	a2,1118(a2) # 1020 <num_threads>
 bca:	00000497          	auipc	s1,0x0
 bce:	44e48493          	addi	s1,s1,1102 # 1018 <stacks>
 bd2:	0036161b          	slliw	a2,a2,0x3
 bd6:	608c                	ld	a1,0(s1)
 bd8:	00000097          	auipc	ra,0x0
 bdc:	8d8080e7          	jalr	-1832(ra) # 4b0 <memmove>
  free(stacks);
 be0:	6088                	ld	a0,0(s1)
 be2:	00000097          	auipc	ra,0x0
 be6:	d8c080e7          	jalr	-628(ra) # 96e <free>
  stacks = new_stacks;
 bea:	0124b023          	sd	s2,0(s1)
}
 bee:	4501                	li	a0,0
 bf0:	60e2                	ld	ra,24(sp)
 bf2:	6442                	ld	s0,16(sp)
 bf4:	64a2                	ld	s1,8(sp)
 bf6:	6902                	ld	s2,0(sp)
 bf8:	6105                	addi	sp,sp,32
 bfa:	8082                	ret

0000000000000bfc <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 bfc:	7179                	addi	sp,sp,-48
 bfe:	f406                	sd	ra,40(sp)
 c00:	f022                	sd	s0,32(sp)
 c02:	e84a                	sd	s2,16(sp)
 c04:	e44e                	sd	s3,8(sp)
 c06:	1800                	addi	s0,sp,48
 c08:	892a                	mv	s2,a0
 c0a:	89ae                	mv	s3,a1
  if (stacks == 0) {
 c0c:	00000797          	auipc	a5,0x0
 c10:	40c7b783          	ld	a5,1036(a5) # 1018 <stacks>
 c14:	c3d9                	beqz	a5,c9a <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 c16:	00000797          	auipc	a5,0x0
 c1a:	3ea7a783          	lw	a5,1002(a5) # 1000 <max_stacks>
 c1e:	00000717          	auipc	a4,0x0
 c22:	40272703          	lw	a4,1026(a4) # 1020 <num_threads>
 c26:	0af71363          	bne	a4,a5,ccc <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 c2a:	04000713          	li	a4,64
 c2e:	08e78563          	beq	a5,a4,cb8 <ithread_create+0xbc>
 c32:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 c34:	00000097          	auipc	ra,0x0
 c38:	f64080e7          	jalr	-156(ra) # b98 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 c3c:	6505                	lui	a0,0x1
 c3e:	00000097          	auipc	ra,0x0
 c42:	db2080e7          	jalr	-590(ra) # 9f0 <malloc>
 c46:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 c48:	00000717          	auipc	a4,0x0
 c4c:	3d872703          	lw	a4,984(a4) # 1020 <num_threads>
 c50:	070e                	slli	a4,a4,0x3
 c52:	00000797          	auipc	a5,0x0
 c56:	3c67b783          	ld	a5,966(a5) # 1018 <stacks>
 c5a:	97ba                	add	a5,a5,a4
 c5c:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 c5e:	00000697          	auipc	a3,0x0
 c62:	e9268693          	addi	a3,a3,-366 # af0 <ithread_exit>
 c66:	862a                	mv	a2,a0
 c68:	85ce                	mv	a1,s3
 c6a:	854a                	mv	a0,s2
 c6c:	00000097          	auipc	ra,0x0
 c70:	99e080e7          	jalr	-1634(ra) # 60a <create_thread>
 c74:	892a                	mv	s2,a0
  if (res != -1) {
 c76:	57fd                	li	a5,-1
 c78:	04f50c63          	beq	a0,a5,cd0 <ithread_create+0xd4>
    num_threads++;
 c7c:	00000717          	auipc	a4,0x0
 c80:	3a470713          	addi	a4,a4,932 # 1020 <num_threads>
 c84:	431c                	lw	a5,0(a4)
 c86:	2785                	addiw	a5,a5,1
 c88:	c31c                	sw	a5,0(a4)
 c8a:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 c8c:	854a                	mv	a0,s2
 c8e:	70a2                	ld	ra,40(sp)
 c90:	7402                	ld	s0,32(sp)
 c92:	6942                	ld	s2,16(sp)
 c94:	69a2                	ld	s3,8(sp)
 c96:	6145                	addi	sp,sp,48
 c98:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 c9a:	00000517          	auipc	a0,0x0
 c9e:	36652503          	lw	a0,870(a0) # 1000 <max_stacks>
 ca2:	0035151b          	slliw	a0,a0,0x3
 ca6:	00000097          	auipc	ra,0x0
 caa:	d4a080e7          	jalr	-694(ra) # 9f0 <malloc>
 cae:	00000797          	auipc	a5,0x0
 cb2:	36a7b523          	sd	a0,874(a5) # 1018 <stacks>
 cb6:	b785                	j	c16 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 cb8:	00000517          	auipc	a0,0x0
 cbc:	11050513          	addi	a0,a0,272 # dc8 <ithread_join+0xd2>
 cc0:	00000097          	auipc	ra,0x0
 cc4:	c78080e7          	jalr	-904(ra) # 938 <printf>
      return -1;
 cc8:	597d                	li	s2,-1
 cca:	b7c9                	j	c8c <ithread_create+0x90>
 ccc:	ec26                	sd	s1,24(sp)
 cce:	b7bd                	j	c3c <ithread_create+0x40>
    free(stack_ptr);
 cd0:	8526                	mv	a0,s1
 cd2:	00000097          	auipc	ra,0x0
 cd6:	c9c080e7          	jalr	-868(ra) # 96e <free>
    stacks[num_threads] = 0;
 cda:	00000717          	auipc	a4,0x0
 cde:	34672703          	lw	a4,838(a4) # 1020 <num_threads>
 ce2:	070e                	slli	a4,a4,0x3
 ce4:	00000797          	auipc	a5,0x0
 ce8:	3347b783          	ld	a5,820(a5) # 1018 <stacks>
 cec:	97ba                	add	a5,a5,a4
 cee:	0007b023          	sd	zero,0(a5)
 cf2:	64e2                	ld	s1,24(sp)
 cf4:	bf61                	j	c8c <ithread_create+0x90>

0000000000000cf6 <ithread_join>:

int ithread_join(int thread_id) {
 cf6:	1101                	addi	sp,sp,-32
 cf8:	ec06                	sd	ra,24(sp)
 cfa:	e822                	sd	s0,16(sp)
 cfc:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 cfe:	ff040793          	addi	a5,s0,-16
 d02:	ffc7859b          	addiw	a1,a5,-4
 d06:	00000097          	auipc	ra,0x0
 d0a:	90c080e7          	jalr	-1780(ra) # 612 <join_thread>
  threads_done++;
 d0e:	00000717          	auipc	a4,0x0
 d12:	31670713          	addi	a4,a4,790 # 1024 <threads_done>
 d16:	431c                	lw	a5,0(a4)
 d18:	2785                	addiw	a5,a5,1
 d1a:	0007869b          	sext.w	a3,a5
 d1e:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 d20:	00000797          	auipc	a5,0x0
 d24:	3007a783          	lw	a5,768(a5) # 1020 <num_threads>
 d28:	00d78863          	beq	a5,a3,d38 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 d2c:	fec42503          	lw	a0,-20(s0)
 d30:	60e2                	ld	ra,24(sp)
 d32:	6442                	ld	s0,16(sp)
 d34:	6105                	addi	sp,sp,32
 d36:	8082                	ret
    free_stacks();
 d38:	00000097          	auipc	ra,0x0
 d3c:	dd2080e7          	jalr	-558(ra) # b0a <free_stacks>
 d40:	b7f5                	j	d2c <ithread_join+0x36>
