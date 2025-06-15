
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	b2250513          	addi	a0,a0,-1246 # b30 <ithread_join+0x4e>
  16:	00000097          	auipc	ra,0x0
  1a:	3ca080e7          	jalr	970(ra) # 3e0 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3f4080e7          	jalr	1012(ra) # 418 <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3ea080e7          	jalr	1002(ra) # 418 <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	b0290913          	addi	s2,s2,-1278 # b38 <ithread_join+0x56>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6e6080e7          	jalr	1766(ra) # 726 <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	350080e7          	jalr	848(ra) # 398 <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	34e080e7          	jalr	846(ra) # 3a8 <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	b1e50513          	addi	a0,a0,-1250 # b88 <ithread_join+0xa6>
  72:	00000097          	auipc	ra,0x0
  76:	6b4080e7          	jalr	1716(ra) # 726 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	324080e7          	jalr	804(ra) # 3a0 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	aa850513          	addi	a0,a0,-1368 # b30 <ithread_join+0x4e>
  90:	00000097          	auipc	ra,0x0
  94:	358080e7          	jalr	856(ra) # 3e8 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	a9650513          	addi	a0,a0,-1386 # b30 <ithread_join+0x4e>
  a2:	00000097          	auipc	ra,0x0
  a6:	33e080e7          	jalr	830(ra) # 3e0 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	aa450513          	addi	a0,a0,-1372 # b50 <ithread_join+0x6e>
  b4:	00000097          	auipc	ra,0x0
  b8:	672080e7          	jalr	1650(ra) # 726 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2e2080e7          	jalr	738(ra) # 3a0 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	44a58593          	addi	a1,a1,1098 # 1510 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	a9a50513          	addi	a0,a0,-1382 # b68 <ithread_join+0x86>
  d6:	00000097          	auipc	ra,0x0
  da:	302080e7          	jalr	770(ra) # 3d8 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	a9250513          	addi	a0,a0,-1390 # b70 <ithread_join+0x8e>
  e6:	00000097          	auipc	ra,0x0
  ea:	640080e7          	jalr	1600(ra) # 726 <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	2b0080e7          	jalr	688(ra) # 3a0 <exit>

00000000000000f8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  extern int main();
  main();
 100:	00000097          	auipc	ra,0x0
 104:	f00080e7          	jalr	-256(ra) # 0 <main>
  exit(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	296080e7          	jalr	662(ra) # 3a0 <exit>

0000000000000112 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11a:	87aa                	mv	a5,a0
 11c:	0585                	addi	a1,a1,1
 11e:	0785                	addi	a5,a5,1
 120:	fff5c703          	lbu	a4,-1(a1)
 124:	fee78fa3          	sb	a4,-1(a5)
 128:	fb75                	bnez	a4,11c <strcpy+0xa>
    ;
  return os;
}
 12a:	60a2                	ld	ra,8(sp)
 12c:	6402                	ld	s0,0(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 132:	1141                	addi	sp,sp,-16
 134:	e406                	sd	ra,8(sp)
 136:	e022                	sd	s0,0(sp)
 138:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cb91                	beqz	a5,152 <strcmp+0x20>
 140:	0005c703          	lbu	a4,0(a1)
 144:	00f71763          	bne	a4,a5,152 <strcmp+0x20>
    p++, q++;
 148:	0505                	addi	a0,a0,1
 14a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 14c:	00054783          	lbu	a5,0(a0)
 150:	fbe5                	bnez	a5,140 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 152:	0005c503          	lbu	a0,0(a1)
}
 156:	40a7853b          	subw	a0,a5,a0
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strlen>:

uint
strlen(const char *s)
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cf91                	beqz	a5,18a <strlen+0x28>
 170:	00150793          	addi	a5,a0,1
 174:	86be                	mv	a3,a5
 176:	0785                	addi	a5,a5,1
 178:	fff7c703          	lbu	a4,-1(a5)
 17c:	ff65                	bnez	a4,174 <strlen+0x12>
 17e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 182:	60a2                	ld	ra,8(sp)
 184:	6402                	ld	s0,0(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret
  for(n = 0; s[n]; n++)
 18a:	4501                	li	a0,0
 18c:	bfdd                	j	182 <strlen+0x20>

000000000000018e <memset>:

void*
memset(void *dst, int c, uint n)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e406                	sd	ra,8(sp)
 192:	e022                	sd	s0,0(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 196:	ca19                	beqz	a2,1ac <memset+0x1e>
 198:	87aa                	mv	a5,a0
 19a:	1602                	slli	a2,a2,0x20
 19c:	9201                	srli	a2,a2,0x20
 19e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a6:	0785                	addi	a5,a5,1
 1a8:	fee79de3          	bne	a5,a4,1a2 <memset+0x14>
  }
  return dst;
}
 1ac:	60a2                	ld	ra,8(sp)
 1ae:	6402                	ld	s0,0(sp)
 1b0:	0141                	addi	sp,sp,16
 1b2:	8082                	ret

00000000000001b4 <strchr>:

char*
strchr(const char *s, char c)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e406                	sd	ra,8(sp)
 1b8:	e022                	sd	s0,0(sp)
 1ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cf81                	beqz	a5,1d8 <strchr+0x24>
    if(*s == c)
 1c2:	00f58763          	beq	a1,a5,1d0 <strchr+0x1c>
  for(; *s; s++)
 1c6:	0505                	addi	a0,a0,1
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	fbfd                	bnez	a5,1c2 <strchr+0xe>
      return (char*)s;
  return 0;
 1ce:	4501                	li	a0,0
}
 1d0:	60a2                	ld	ra,8(sp)
 1d2:	6402                	ld	s0,0(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret
  return 0;
 1d8:	4501                	li	a0,0
 1da:	bfdd                	j	1d0 <strchr+0x1c>

00000000000001dc <gets>:

char*
gets(char *buf, int max)
{
 1dc:	711d                	addi	sp,sp,-96
 1de:	ec86                	sd	ra,88(sp)
 1e0:	e8a2                	sd	s0,80(sp)
 1e2:	e4a6                	sd	s1,72(sp)
 1e4:	e0ca                	sd	s2,64(sp)
 1e6:	fc4e                	sd	s3,56(sp)
 1e8:	f852                	sd	s4,48(sp)
 1ea:	f456                	sd	s5,40(sp)
 1ec:	f05a                	sd	s6,32(sp)
 1ee:	ec5e                	sd	s7,24(sp)
 1f0:	e862                	sd	s8,16(sp)
 1f2:	1080                	addi	s0,sp,96
 1f4:	8baa                	mv	s7,a0
 1f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f8:	892a                	mv	s2,a0
 1fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1fc:	faf40b13          	addi	s6,s0,-81
 200:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 202:	8c26                	mv	s8,s1
 204:	0014899b          	addiw	s3,s1,1
 208:	84ce                	mv	s1,s3
 20a:	0349d663          	bge	s3,s4,236 <gets+0x5a>
    cc = read(0, &c, 1);
 20e:	8656                	mv	a2,s5
 210:	85da                	mv	a1,s6
 212:	4501                	li	a0,0
 214:	00000097          	auipc	ra,0x0
 218:	1a4080e7          	jalr	420(ra) # 3b8 <read>
    if(cc < 1)
 21c:	00a05d63          	blez	a0,236 <gets+0x5a>
      break;
    buf[i++] = c;
 220:	faf44783          	lbu	a5,-81(s0)
 224:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 228:	0905                	addi	s2,s2,1
 22a:	ff678713          	addi	a4,a5,-10
 22e:	c319                	beqz	a4,234 <gets+0x58>
 230:	17cd                	addi	a5,a5,-13
 232:	fbe1                	bnez	a5,202 <gets+0x26>
    buf[i++] = c;
 234:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 236:	9c5e                	add	s8,s8,s7
 238:	000c0023          	sb	zero,0(s8)
  return buf;
}
 23c:	855e                	mv	a0,s7
 23e:	60e6                	ld	ra,88(sp)
 240:	6446                	ld	s0,80(sp)
 242:	64a6                	ld	s1,72(sp)
 244:	6906                	ld	s2,64(sp)
 246:	79e2                	ld	s3,56(sp)
 248:	7a42                	ld	s4,48(sp)
 24a:	7aa2                	ld	s5,40(sp)
 24c:	7b02                	ld	s6,32(sp)
 24e:	6be2                	ld	s7,24(sp)
 250:	6c42                	ld	s8,16(sp)
 252:	6125                	addi	sp,sp,96
 254:	8082                	ret

0000000000000256 <stat>:

int
stat(const char *n, struct stat *st)
{
 256:	1101                	addi	sp,sp,-32
 258:	ec06                	sd	ra,24(sp)
 25a:	e822                	sd	s0,16(sp)
 25c:	e04a                	sd	s2,0(sp)
 25e:	1000                	addi	s0,sp,32
 260:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 262:	4581                	li	a1,0
 264:	00000097          	auipc	ra,0x0
 268:	17c080e7          	jalr	380(ra) # 3e0 <open>
  if(fd < 0)
 26c:	02054663          	bltz	a0,298 <stat+0x42>
 270:	e426                	sd	s1,8(sp)
 272:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 274:	85ca                	mv	a1,s2
 276:	00000097          	auipc	ra,0x0
 27a:	182080e7          	jalr	386(ra) # 3f8 <fstat>
 27e:	892a                	mv	s2,a0
  close(fd);
 280:	8526                	mv	a0,s1
 282:	00000097          	auipc	ra,0x0
 286:	146080e7          	jalr	326(ra) # 3c8 <close>
  return r;
 28a:	64a2                	ld	s1,8(sp)
}
 28c:	854a                	mv	a0,s2
 28e:	60e2                	ld	ra,24(sp)
 290:	6442                	ld	s0,16(sp)
 292:	6902                	ld	s2,0(sp)
 294:	6105                	addi	sp,sp,32
 296:	8082                	ret
    return -1;
 298:	57fd                	li	a5,-1
 29a:	893e                	mv	s2,a5
 29c:	bfc5                	j	28c <stat+0x36>

000000000000029e <atoi>:

int
atoi(const char *s)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e406                	sd	ra,8(sp)
 2a2:	e022                	sd	s0,0(sp)
 2a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a6:	00054683          	lbu	a3,0(a0)
 2aa:	fd06879b          	addiw	a5,a3,-48
 2ae:	0ff7f793          	zext.b	a5,a5
 2b2:	4625                	li	a2,9
 2b4:	02f66963          	bltu	a2,a5,2e6 <atoi+0x48>
 2b8:	872a                	mv	a4,a0
  n = 0;
 2ba:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2bc:	0705                	addi	a4,a4,1
 2be:	0025179b          	slliw	a5,a0,0x2
 2c2:	9fa9                	addw	a5,a5,a0
 2c4:	0017979b          	slliw	a5,a5,0x1
 2c8:	9fb5                	addw	a5,a5,a3
 2ca:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ce:	00074683          	lbu	a3,0(a4)
 2d2:	fd06879b          	addiw	a5,a3,-48
 2d6:	0ff7f793          	zext.b	a5,a5
 2da:	fef671e3          	bgeu	a2,a5,2bc <atoi+0x1e>
  return n;
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret
  n = 0;
 2e6:	4501                	li	a0,0
 2e8:	bfdd                	j	2de <atoi+0x40>

00000000000002ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f2:	02b57563          	bgeu	a0,a1,31c <memmove+0x32>
    while(n-- > 0)
 2f6:	00c05f63          	blez	a2,314 <memmove+0x2a>
 2fa:	1602                	slli	a2,a2,0x20
 2fc:	9201                	srli	a2,a2,0x20
 2fe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 302:	872a                	mv	a4,a0
      *dst++ = *src++;
 304:	0585                	addi	a1,a1,1
 306:	0705                	addi	a4,a4,1
 308:	fff5c683          	lbu	a3,-1(a1)
 30c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 310:	fee79ae3          	bne	a5,a4,304 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret
    while(n-- > 0)
 31c:	fec05ce3          	blez	a2,314 <memmove+0x2a>
    dst += n;
 320:	00c50733          	add	a4,a0,a2
    src += n;
 324:	95b2                	add	a1,a1,a2
 326:	fff6079b          	addiw	a5,a2,-1
 32a:	1782                	slli	a5,a5,0x20
 32c:	9381                	srli	a5,a5,0x20
 32e:	fff7c793          	not	a5,a5
 332:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 334:	15fd                	addi	a1,a1,-1
 336:	177d                	addi	a4,a4,-1
 338:	0005c683          	lbu	a3,0(a1)
 33c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 340:	fef71ae3          	bne	a4,a5,334 <memmove+0x4a>
 344:	bfc1                	j	314 <memmove+0x2a>

0000000000000346 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 346:	1141                	addi	sp,sp,-16
 348:	e406                	sd	ra,8(sp)
 34a:	e022                	sd	s0,0(sp)
 34c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 34e:	c61d                	beqz	a2,37c <memcmp+0x36>
 350:	1602                	slli	a2,a2,0x20
 352:	9201                	srli	a2,a2,0x20
 354:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 358:	00054783          	lbu	a5,0(a0)
 35c:	0005c703          	lbu	a4,0(a1)
 360:	00e79863          	bne	a5,a4,370 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 364:	0505                	addi	a0,a0,1
    p2++;
 366:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 368:	fed518e3          	bne	a0,a3,358 <memcmp+0x12>
  }
  return 0;
 36c:	4501                	li	a0,0
 36e:	a019                	j	374 <memcmp+0x2e>
      return *p1 - *p2;
 370:	40e7853b          	subw	a0,a5,a4
}
 374:	60a2                	ld	ra,8(sp)
 376:	6402                	ld	s0,0(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret
  return 0;
 37c:	4501                	li	a0,0
 37e:	bfdd                	j	374 <memcmp+0x2e>

0000000000000380 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 380:	1141                	addi	sp,sp,-16
 382:	e406                	sd	ra,8(sp)
 384:	e022                	sd	s0,0(sp)
 386:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 388:	00000097          	auipc	ra,0x0
 38c:	f62080e7          	jalr	-158(ra) # 2ea <memmove>
}
 390:	60a2                	ld	ra,8(sp)
 392:	6402                	ld	s0,0(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret

0000000000000398 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 398:	4885                	li	a7,1
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a0:	4889                	li	a7,2
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a8:	488d                	li	a7,3
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b0:	4891                	li	a7,4
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <read>:
.global read
read:
 li a7, SYS_read
 3b8:	4895                	li	a7,5
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <write>:
.global write
write:
 li a7, SYS_write
 3c0:	48c1                	li	a7,16
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <close>:
.global close
close:
 li a7, SYS_close
 3c8:	48d5                	li	a7,21
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d0:	4899                	li	a7,6
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d8:	489d                	li	a7,7
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <open>:
.global open
open:
 li a7, SYS_open
 3e0:	48bd                	li	a7,15
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e8:	48c5                	li	a7,17
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f0:	48c9                	li	a7,18
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f8:	48a1                	li	a7,8
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <link>:
.global link
link:
 li a7, SYS_link
 400:	48cd                	li	a7,19
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 408:	48d1                	li	a7,20
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 410:	48a5                	li	a7,9
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <dup>:
.global dup
dup:
 li a7, SYS_dup
 418:	48a9                	li	a7,10
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 420:	48ad                	li	a7,11
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 428:	48b1                	li	a7,12
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 430:	48b5                	li	a7,13
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 438:	48b9                	li	a7,14
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 440:	48d9                	li	a7,22
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 448:	48dd                	li	a7,23
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 450:	48e1                	li	a7,24
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 458:	48e5                	li	a7,25
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 460:	1101                	addi	sp,sp,-32
 462:	ec06                	sd	ra,24(sp)
 464:	e822                	sd	s0,16(sp)
 466:	1000                	addi	s0,sp,32
 468:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46c:	4605                	li	a2,1
 46e:	fef40593          	addi	a1,s0,-17
 472:	00000097          	auipc	ra,0x0
 476:	f4e080e7          	jalr	-178(ra) # 3c0 <write>
}
 47a:	60e2                	ld	ra,24(sp)
 47c:	6442                	ld	s0,16(sp)
 47e:	6105                	addi	sp,sp,32
 480:	8082                	ret

0000000000000482 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 482:	7139                	addi	sp,sp,-64
 484:	fc06                	sd	ra,56(sp)
 486:	f822                	sd	s0,48(sp)
 488:	f04a                	sd	s2,32(sp)
 48a:	ec4e                	sd	s3,24(sp)
 48c:	0080                	addi	s0,sp,64
 48e:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 490:	cad9                	beqz	a3,526 <printint+0xa4>
 492:	01f5d79b          	srliw	a5,a1,0x1f
 496:	cbc1                	beqz	a5,526 <printint+0xa4>
    neg = 1;
    x = -xx;
 498:	40b005bb          	negw	a1,a1
    neg = 1;
 49c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 49e:	fc040993          	addi	s3,s0,-64
  neg = 0;
 4a2:	86ce                	mv	a3,s3
  i = 0;
 4a4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a6:	00000817          	auipc	a6,0x0
 4aa:	79280813          	addi	a6,a6,1938 # c38 <digits>
 4ae:	88ba                	mv	a7,a4
 4b0:	0017051b          	addiw	a0,a4,1
 4b4:	872a                	mv	a4,a0
 4b6:	02c5f7bb          	remuw	a5,a1,a2
 4ba:	1782                	slli	a5,a5,0x20
 4bc:	9381                	srli	a5,a5,0x20
 4be:	97c2                	add	a5,a5,a6
 4c0:	0007c783          	lbu	a5,0(a5)
 4c4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c8:	87ae                	mv	a5,a1
 4ca:	02c5d5bb          	divuw	a1,a1,a2
 4ce:	0685                	addi	a3,a3,1
 4d0:	fcc7ffe3          	bgeu	a5,a2,4ae <printint+0x2c>
  if(neg)
 4d4:	00030c63          	beqz	t1,4ec <printint+0x6a>
    buf[i++] = '-';
 4d8:	fd050793          	addi	a5,a0,-48
 4dc:	00878533          	add	a0,a5,s0
 4e0:	02d00793          	li	a5,45
 4e4:	fef50823          	sb	a5,-16(a0)
 4e8:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4ec:	02e05763          	blez	a4,51a <printint+0x98>
 4f0:	f426                	sd	s1,40(sp)
 4f2:	377d                	addiw	a4,a4,-1
 4f4:	00e984b3          	add	s1,s3,a4
 4f8:	19fd                	addi	s3,s3,-1
 4fa:	99ba                	add	s3,s3,a4
 4fc:	1702                	slli	a4,a4,0x20
 4fe:	9301                	srli	a4,a4,0x20
 500:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 504:	0004c583          	lbu	a1,0(s1)
 508:	854a                	mv	a0,s2
 50a:	00000097          	auipc	ra,0x0
 50e:	f56080e7          	jalr	-170(ra) # 460 <putc>
  while(--i >= 0)
 512:	14fd                	addi	s1,s1,-1
 514:	ff3498e3          	bne	s1,s3,504 <printint+0x82>
 518:	74a2                	ld	s1,40(sp)
}
 51a:	70e2                	ld	ra,56(sp)
 51c:	7442                	ld	s0,48(sp)
 51e:	7902                	ld	s2,32(sp)
 520:	69e2                	ld	s3,24(sp)
 522:	6121                	addi	sp,sp,64
 524:	8082                	ret
  neg = 0;
 526:	4301                	li	t1,0
 528:	bf9d                	j	49e <printint+0x1c>

000000000000052a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 52a:	715d                	addi	sp,sp,-80
 52c:	e486                	sd	ra,72(sp)
 52e:	e0a2                	sd	s0,64(sp)
 530:	f84a                	sd	s2,48(sp)
 532:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 534:	0005c903          	lbu	s2,0(a1)
 538:	1a090b63          	beqz	s2,6ee <vprintf+0x1c4>
 53c:	fc26                	sd	s1,56(sp)
 53e:	f44e                	sd	s3,40(sp)
 540:	f052                	sd	s4,32(sp)
 542:	ec56                	sd	s5,24(sp)
 544:	e85a                	sd	s6,16(sp)
 546:	e45e                	sd	s7,8(sp)
 548:	8aaa                	mv	s5,a0
 54a:	8bb2                	mv	s7,a2
 54c:	00158493          	addi	s1,a1,1
  state = 0;
 550:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 552:	02500a13          	li	s4,37
 556:	4b55                	li	s6,21
 558:	a839                	j	576 <vprintf+0x4c>
        putc(fd, c);
 55a:	85ca                	mv	a1,s2
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	f02080e7          	jalr	-254(ra) # 460 <putc>
 566:	a019                	j	56c <vprintf+0x42>
    } else if(state == '%'){
 568:	01498d63          	beq	s3,s4,582 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 56c:	0485                	addi	s1,s1,1
 56e:	fff4c903          	lbu	s2,-1(s1)
 572:	16090863          	beqz	s2,6e2 <vprintf+0x1b8>
    if(state == 0){
 576:	fe0999e3          	bnez	s3,568 <vprintf+0x3e>
      if(c == '%'){
 57a:	ff4910e3          	bne	s2,s4,55a <vprintf+0x30>
        state = '%';
 57e:	89d2                	mv	s3,s4
 580:	b7f5                	j	56c <vprintf+0x42>
      if(c == 'd'){
 582:	13490563          	beq	s2,s4,6ac <vprintf+0x182>
 586:	f9d9079b          	addiw	a5,s2,-99
 58a:	0ff7f793          	zext.b	a5,a5
 58e:	12fb6863          	bltu	s6,a5,6be <vprintf+0x194>
 592:	f9d9079b          	addiw	a5,s2,-99
 596:	0ff7f713          	zext.b	a4,a5
 59a:	12eb6263          	bltu	s6,a4,6be <vprintf+0x194>
 59e:	00271793          	slli	a5,a4,0x2
 5a2:	00000717          	auipc	a4,0x0
 5a6:	63e70713          	addi	a4,a4,1598 # be0 <ithread_join+0xfe>
 5aa:	97ba                	add	a5,a5,a4
 5ac:	439c                	lw	a5,0(a5)
 5ae:	97ba                	add	a5,a5,a4
 5b0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5b2:	008b8913          	addi	s2,s7,8
 5b6:	4685                	li	a3,1
 5b8:	4629                	li	a2,10
 5ba:	000ba583          	lw	a1,0(s7)
 5be:	8556                	mv	a0,s5
 5c0:	00000097          	auipc	ra,0x0
 5c4:	ec2080e7          	jalr	-318(ra) # 482 <printint>
 5c8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b745                	j	56c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ce:	008b8913          	addi	s2,s7,8
 5d2:	4681                	li	a3,0
 5d4:	4629                	li	a2,10
 5d6:	000ba583          	lw	a1,0(s7)
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	ea6080e7          	jalr	-346(ra) # 482 <printint>
 5e4:	8bca                	mv	s7,s2
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	b751                	j	56c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5ea:	008b8913          	addi	s2,s7,8
 5ee:	4681                	li	a3,0
 5f0:	4641                	li	a2,16
 5f2:	000ba583          	lw	a1,0(s7)
 5f6:	8556                	mv	a0,s5
 5f8:	00000097          	auipc	ra,0x0
 5fc:	e8a080e7          	jalr	-374(ra) # 482 <printint>
 600:	8bca                	mv	s7,s2
      state = 0;
 602:	4981                	li	s3,0
 604:	b7a5                	j	56c <vprintf+0x42>
 606:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 608:	008b8793          	addi	a5,s7,8
 60c:	8c3e                	mv	s8,a5
 60e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 612:	03000593          	li	a1,48
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	e48080e7          	jalr	-440(ra) # 460 <putc>
  putc(fd, 'x');
 620:	07800593          	li	a1,120
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	e3a080e7          	jalr	-454(ra) # 460 <putc>
 62e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 630:	00000b97          	auipc	s7,0x0
 634:	608b8b93          	addi	s7,s7,1544 # c38 <digits>
 638:	03c9d793          	srli	a5,s3,0x3c
 63c:	97de                	add	a5,a5,s7
 63e:	0007c583          	lbu	a1,0(a5)
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	e1c080e7          	jalr	-484(ra) # 460 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64c:	0992                	slli	s3,s3,0x4
 64e:	397d                	addiw	s2,s2,-1
 650:	fe0914e3          	bnez	s2,638 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 654:	8be2                	mv	s7,s8
      state = 0;
 656:	4981                	li	s3,0
 658:	6c02                	ld	s8,0(sp)
 65a:	bf09                	j	56c <vprintf+0x42>
        s = va_arg(ap, char*);
 65c:	008b8993          	addi	s3,s7,8
 660:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 664:	02090163          	beqz	s2,686 <vprintf+0x15c>
        while(*s != 0){
 668:	00094583          	lbu	a1,0(s2)
 66c:	c9a5                	beqz	a1,6dc <vprintf+0x1b2>
          putc(fd, *s);
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	df0080e7          	jalr	-528(ra) # 460 <putc>
          s++;
 678:	0905                	addi	s2,s2,1
        while(*s != 0){
 67a:	00094583          	lbu	a1,0(s2)
 67e:	f9e5                	bnez	a1,66e <vprintf+0x144>
        s = va_arg(ap, char*);
 680:	8bce                	mv	s7,s3
      state = 0;
 682:	4981                	li	s3,0
 684:	b5e5                	j	56c <vprintf+0x42>
          s = "(null)";
 686:	00000917          	auipc	s2,0x0
 68a:	52290913          	addi	s2,s2,1314 # ba8 <ithread_join+0xc6>
        while(*s != 0){
 68e:	02800593          	li	a1,40
 692:	bff1                	j	66e <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 694:	008b8913          	addi	s2,s7,8
 698:	000bc583          	lbu	a1,0(s7)
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	dc2080e7          	jalr	-574(ra) # 460 <putc>
 6a6:	8bca                	mv	s7,s2
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b5c9                	j	56c <vprintf+0x42>
        putc(fd, c);
 6ac:	02500593          	li	a1,37
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	dae080e7          	jalr	-594(ra) # 460 <putc>
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bd45                	j	56c <vprintf+0x42>
        putc(fd, '%');
 6be:	02500593          	li	a1,37
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	d9c080e7          	jalr	-612(ra) # 460 <putc>
        putc(fd, c);
 6cc:	85ca                	mv	a1,s2
 6ce:	8556                	mv	a0,s5
 6d0:	00000097          	auipc	ra,0x0
 6d4:	d90080e7          	jalr	-624(ra) # 460 <putc>
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bd49                	j	56c <vprintf+0x42>
        s = va_arg(ap, char*);
 6dc:	8bce                	mv	s7,s3
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	b571                	j	56c <vprintf+0x42>
 6e2:	74e2                	ld	s1,56(sp)
 6e4:	79a2                	ld	s3,40(sp)
 6e6:	7a02                	ld	s4,32(sp)
 6e8:	6ae2                	ld	s5,24(sp)
 6ea:	6b42                	ld	s6,16(sp)
 6ec:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6ee:	60a6                	ld	ra,72(sp)
 6f0:	6406                	ld	s0,64(sp)
 6f2:	7942                	ld	s2,48(sp)
 6f4:	6161                	addi	sp,sp,80
 6f6:	8082                	ret

00000000000006f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f8:	715d                	addi	sp,sp,-80
 6fa:	ec06                	sd	ra,24(sp)
 6fc:	e822                	sd	s0,16(sp)
 6fe:	1000                	addi	s0,sp,32
 700:	e010                	sd	a2,0(s0)
 702:	e414                	sd	a3,8(s0)
 704:	e818                	sd	a4,16(s0)
 706:	ec1c                	sd	a5,24(s0)
 708:	03043023          	sd	a6,32(s0)
 70c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 710:	8622                	mv	a2,s0
 712:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 716:	00000097          	auipc	ra,0x0
 71a:	e14080e7          	jalr	-492(ra) # 52a <vprintf>
}
 71e:	60e2                	ld	ra,24(sp)
 720:	6442                	ld	s0,16(sp)
 722:	6161                	addi	sp,sp,80
 724:	8082                	ret

0000000000000726 <printf>:

void
printf(const char *fmt, ...)
{
 726:	711d                	addi	sp,sp,-96
 728:	ec06                	sd	ra,24(sp)
 72a:	e822                	sd	s0,16(sp)
 72c:	1000                	addi	s0,sp,32
 72e:	e40c                	sd	a1,8(s0)
 730:	e810                	sd	a2,16(s0)
 732:	ec14                	sd	a3,24(s0)
 734:	f018                	sd	a4,32(s0)
 736:	f41c                	sd	a5,40(s0)
 738:	03043823          	sd	a6,48(s0)
 73c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 740:	00840613          	addi	a2,s0,8
 744:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 748:	85aa                	mv	a1,a0
 74a:	4505                	li	a0,1
 74c:	00000097          	auipc	ra,0x0
 750:	dde080e7          	jalr	-546(ra) # 52a <vprintf>
}
 754:	60e2                	ld	ra,24(sp)
 756:	6442                	ld	s0,16(sp)
 758:	6125                	addi	sp,sp,96
 75a:	8082                	ret

000000000000075c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75c:	1141                	addi	sp,sp,-16
 75e:	e406                	sd	ra,8(sp)
 760:	e022                	sd	s0,0(sp)
 762:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 764:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 768:	00001797          	auipc	a5,0x1
 76c:	db87b783          	ld	a5,-584(a5) # 1520 <freep>
 770:	a039                	j	77e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 772:	6398                	ld	a4,0(a5)
 774:	00e7e463          	bltu	a5,a4,77c <free+0x20>
 778:	00e6ea63          	bltu	a3,a4,78c <free+0x30>
{
 77c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77e:	fed7fae3          	bgeu	a5,a3,772 <free+0x16>
 782:	6398                	ld	a4,0(a5)
 784:	00e6e463          	bltu	a3,a4,78c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 788:	fee7eae3          	bltu	a5,a4,77c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 78c:	ff852583          	lw	a1,-8(a0)
 790:	6390                	ld	a2,0(a5)
 792:	02059813          	slli	a6,a1,0x20
 796:	01c85713          	srli	a4,a6,0x1c
 79a:	9736                	add	a4,a4,a3
 79c:	02e60563          	beq	a2,a4,7c6 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7a0:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7a4:	4790                	lw	a2,8(a5)
 7a6:	02061593          	slli	a1,a2,0x20
 7aa:	01c5d713          	srli	a4,a1,0x1c
 7ae:	973e                	add	a4,a4,a5
 7b0:	02e68263          	beq	a3,a4,7d4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7b4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7b6:	00001717          	auipc	a4,0x1
 7ba:	d6f73523          	sd	a5,-662(a4) # 1520 <freep>
}
 7be:	60a2                	ld	ra,8(sp)
 7c0:	6402                	ld	s0,0(sp)
 7c2:	0141                	addi	sp,sp,16
 7c4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7c6:	4618                	lw	a4,8(a2)
 7c8:	9f2d                	addw	a4,a4,a1
 7ca:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	6398                	ld	a4,0(a5)
 7d0:	6310                	ld	a2,0(a4)
 7d2:	b7f9                	j	7a0 <free+0x44>
    p->s.size += bp->s.size;
 7d4:	ff852703          	lw	a4,-8(a0)
 7d8:	9f31                	addw	a4,a4,a2
 7da:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7dc:	ff053683          	ld	a3,-16(a0)
 7e0:	bfd1                	j	7b4 <free+0x58>

00000000000007e2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e2:	7139                	addi	sp,sp,-64
 7e4:	fc06                	sd	ra,56(sp)
 7e6:	f822                	sd	s0,48(sp)
 7e8:	f04a                	sd	s2,32(sp)
 7ea:	ec4e                	sd	s3,24(sp)
 7ec:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ee:	02051993          	slli	s3,a0,0x20
 7f2:	0209d993          	srli	s3,s3,0x20
 7f6:	09bd                	addi	s3,s3,15
 7f8:	0049d993          	srli	s3,s3,0x4
 7fc:	2985                	addiw	s3,s3,1
 7fe:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 800:	00001517          	auipc	a0,0x1
 804:	d2053503          	ld	a0,-736(a0) # 1520 <freep>
 808:	c905                	beqz	a0,838 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80c:	4798                	lw	a4,8(a5)
 80e:	09377a63          	bgeu	a4,s3,8a2 <malloc+0xc0>
 812:	f426                	sd	s1,40(sp)
 814:	e852                	sd	s4,16(sp)
 816:	e456                	sd	s5,8(sp)
 818:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 81a:	8a4e                	mv	s4,s3
 81c:	6705                	lui	a4,0x1
 81e:	00e9f363          	bgeu	s3,a4,824 <malloc+0x42>
 822:	6a05                	lui	s4,0x1
 824:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 828:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82c:	00001497          	auipc	s1,0x1
 830:	cf448493          	addi	s1,s1,-780 # 1520 <freep>
  if(p == (char*)-1)
 834:	5afd                	li	s5,-1
 836:	a089                	j	878 <malloc+0x96>
 838:	f426                	sd	s1,40(sp)
 83a:	e852                	sd	s4,16(sp)
 83c:	e456                	sd	s5,8(sp)
 83e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 840:	00001797          	auipc	a5,0x1
 844:	d0078793          	addi	a5,a5,-768 # 1540 <base>
 848:	00001717          	auipc	a4,0x1
 84c:	ccf73c23          	sd	a5,-808(a4) # 1520 <freep>
 850:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 852:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 856:	b7d1                	j	81a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 858:	6398                	ld	a4,0(a5)
 85a:	e118                	sd	a4,0(a0)
 85c:	a8b9                	j	8ba <malloc+0xd8>
  hp->s.size = nu;
 85e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 862:	0541                	addi	a0,a0,16
 864:	00000097          	auipc	ra,0x0
 868:	ef8080e7          	jalr	-264(ra) # 75c <free>
  return freep;
 86c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 86e:	c135                	beqz	a0,8d2 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 870:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 872:	4798                	lw	a4,8(a5)
 874:	03277363          	bgeu	a4,s2,89a <malloc+0xb8>
    if(p == freep)
 878:	6098                	ld	a4,0(s1)
 87a:	853e                	mv	a0,a5
 87c:	fef71ae3          	bne	a4,a5,870 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 880:	8552                	mv	a0,s4
 882:	00000097          	auipc	ra,0x0
 886:	ba6080e7          	jalr	-1114(ra) # 428 <sbrk>
  if(p == (char*)-1)
 88a:	fd551ae3          	bne	a0,s5,85e <malloc+0x7c>
        return 0;
 88e:	4501                	li	a0,0
 890:	74a2                	ld	s1,40(sp)
 892:	6a42                	ld	s4,16(sp)
 894:	6aa2                	ld	s5,8(sp)
 896:	6b02                	ld	s6,0(sp)
 898:	a03d                	j	8c6 <malloc+0xe4>
 89a:	74a2                	ld	s1,40(sp)
 89c:	6a42                	ld	s4,16(sp)
 89e:	6aa2                	ld	s5,8(sp)
 8a0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8a2:	fae90be3          	beq	s2,a4,858 <malloc+0x76>
        p->s.size -= nunits;
 8a6:	4137073b          	subw	a4,a4,s3
 8aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ac:	02071693          	slli	a3,a4,0x20
 8b0:	01c6d713          	srli	a4,a3,0x1c
 8b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ba:	00001717          	auipc	a4,0x1
 8be:	c6a73323          	sd	a0,-922(a4) # 1520 <freep>
      return (void*)(p + 1);
 8c2:	01078513          	addi	a0,a5,16
  }
}
 8c6:	70e2                	ld	ra,56(sp)
 8c8:	7442                	ld	s0,48(sp)
 8ca:	7902                	ld	s2,32(sp)
 8cc:	69e2                	ld	s3,24(sp)
 8ce:	6121                	addi	sp,sp,64
 8d0:	8082                	ret
 8d2:	74a2                	ld	s1,40(sp)
 8d4:	6a42                	ld	s4,16(sp)
 8d6:	6aa2                	ld	s5,8(sp)
 8d8:	6b02                	ld	s6,0(sp)
 8da:	b7f5                	j	8c6 <malloc+0xe4>

00000000000008dc <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 8dc:	1141                	addi	sp,sp,-16
 8de:	e406                	sd	ra,8(sp)
 8e0:	e022                	sd	s0,0(sp)
 8e2:	0800                	addi	s0,sp,16
  thread_exit(status);
 8e4:	00000097          	auipc	ra,0x0
 8e8:	b74080e7          	jalr	-1164(ra) # 458 <thread_exit>
}
 8ec:	60a2                	ld	ra,8(sp)
 8ee:	6402                	ld	s0,0(sp)
 8f0:	0141                	addi	sp,sp,16
 8f2:	8082                	ret

00000000000008f4 <free_stacks>:
int free_stacks() {
 8f4:	7179                	addi	sp,sp,-48
 8f6:	f406                	sd	ra,40(sp)
 8f8:	f022                	sd	s0,32(sp)
 8fa:	ec26                	sd	s1,24(sp)
 8fc:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8fe:	00001797          	auipc	a5,0x1
 902:	c327a783          	lw	a5,-974(a5) # 1530 <num_threads>
 906:	04f05063          	blez	a5,946 <free_stacks+0x52>
 90a:	e84a                	sd	s2,16(sp)
 90c:	e44e                	sd	s3,8(sp)
 90e:	4481                	li	s1,0
    free(stacks[i]);
 910:	00001997          	auipc	s3,0x1
 914:	c1898993          	addi	s3,s3,-1000 # 1528 <stacks>
  for (int i = 0; i < num_threads; i++) {
 918:	00001917          	auipc	s2,0x1
 91c:	c1890913          	addi	s2,s2,-1000 # 1530 <num_threads>
    free(stacks[i]);
 920:	0009b783          	ld	a5,0(s3)
 924:	00349713          	slli	a4,s1,0x3
 928:	97ba                	add	a5,a5,a4
 92a:	6388                	ld	a0,0(a5)
 92c:	00000097          	auipc	ra,0x0
 930:	e30080e7          	jalr	-464(ra) # 75c <free>
  for (int i = 0; i < num_threads; i++) {
 934:	0485                	addi	s1,s1,1
 936:	00092703          	lw	a4,0(s2)
 93a:	0004879b          	sext.w	a5,s1
 93e:	fee7c1e3          	blt	a5,a4,920 <free_stacks+0x2c>
 942:	6942                	ld	s2,16(sp)
 944:	69a2                	ld	s3,8(sp)
  free(stacks);
 946:	00001497          	auipc	s1,0x1
 94a:	be248493          	addi	s1,s1,-1054 # 1528 <stacks>
 94e:	6088                	ld	a0,0(s1)
 950:	00000097          	auipc	ra,0x0
 954:	e0c080e7          	jalr	-500(ra) # 75c <free>
  stacks = 0;
 958:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 95c:	00001797          	auipc	a5,0x1
 960:	bc07aa23          	sw	zero,-1068(a5) # 1530 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 964:	47a1                	li	a5,8
 966:	00001717          	auipc	a4,0x1
 96a:	b8f72d23          	sw	a5,-1126(a4) # 1500 <max_stacks>
  threads_done = 0;
 96e:	00001797          	auipc	a5,0x1
 972:	bc07a323          	sw	zero,-1082(a5) # 1534 <threads_done>
}
 976:	4501                	li	a0,0
 978:	70a2                	ld	ra,40(sp)
 97a:	7402                	ld	s0,32(sp)
 97c:	64e2                	ld	s1,24(sp)
 97e:	6145                	addi	sp,sp,48
 980:	8082                	ret

0000000000000982 <expand_num_threads>:
int expand_num_threads() {
 982:	1101                	addi	sp,sp,-32
 984:	ec06                	sd	ra,24(sp)
 986:	e822                	sd	s0,16(sp)
 988:	e426                	sd	s1,8(sp)
 98a:	e04a                	sd	s2,0(sp)
 98c:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 98e:	00001797          	auipc	a5,0x1
 992:	b7278793          	addi	a5,a5,-1166 # 1500 <max_stacks>
 996:	4388                	lw	a0,0(a5)
 998:	0015151b          	slliw	a0,a0,0x1
 99c:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 99e:	0035151b          	slliw	a0,a0,0x3
 9a2:	00000097          	auipc	ra,0x0
 9a6:	e40080e7          	jalr	-448(ra) # 7e2 <malloc>
 9aa:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 9ac:	00001617          	auipc	a2,0x1
 9b0:	b8462603          	lw	a2,-1148(a2) # 1530 <num_threads>
 9b4:	00001497          	auipc	s1,0x1
 9b8:	b7448493          	addi	s1,s1,-1164 # 1528 <stacks>
 9bc:	0036161b          	slliw	a2,a2,0x3
 9c0:	608c                	ld	a1,0(s1)
 9c2:	00000097          	auipc	ra,0x0
 9c6:	928080e7          	jalr	-1752(ra) # 2ea <memmove>
  free(stacks);
 9ca:	6088                	ld	a0,0(s1)
 9cc:	00000097          	auipc	ra,0x0
 9d0:	d90080e7          	jalr	-624(ra) # 75c <free>
  stacks = new_stacks;
 9d4:	0124b023          	sd	s2,0(s1)
}
 9d8:	4501                	li	a0,0
 9da:	60e2                	ld	ra,24(sp)
 9dc:	6442                	ld	s0,16(sp)
 9de:	64a2                	ld	s1,8(sp)
 9e0:	6902                	ld	s2,0(sp)
 9e2:	6105                	addi	sp,sp,32
 9e4:	8082                	ret

00000000000009e6 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 9e6:	7179                	addi	sp,sp,-48
 9e8:	f406                	sd	ra,40(sp)
 9ea:	f022                	sd	s0,32(sp)
 9ec:	e84a                	sd	s2,16(sp)
 9ee:	e44e                	sd	s3,8(sp)
 9f0:	1800                	addi	s0,sp,48
 9f2:	892a                	mv	s2,a0
 9f4:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9f6:	00001797          	auipc	a5,0x1
 9fa:	b327b783          	ld	a5,-1230(a5) # 1528 <stacks>
 9fe:	c3d9                	beqz	a5,a84 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a00:	00001797          	auipc	a5,0x1
 a04:	b007a783          	lw	a5,-1280(a5) # 1500 <max_stacks>
 a08:	00001717          	auipc	a4,0x1
 a0c:	b2872703          	lw	a4,-1240(a4) # 1530 <num_threads>
 a10:	0af71463          	bne	a4,a5,ab8 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 a14:	04000713          	li	a4,64
 a18:	08e78563          	beq	a5,a4,aa2 <ithread_create+0xbc>
 a1c:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a1e:	00000097          	auipc	ra,0x0
 a22:	f64080e7          	jalr	-156(ra) # 982 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a26:	6505                	lui	a0,0x1
 a28:	00000097          	auipc	ra,0x0
 a2c:	dba080e7          	jalr	-582(ra) # 7e2 <malloc>
 a30:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a32:	00001717          	auipc	a4,0x1
 a36:	afe72703          	lw	a4,-1282(a4) # 1530 <num_threads>
 a3a:	070e                	slli	a4,a4,0x3
 a3c:	00001797          	auipc	a5,0x1
 a40:	aec7b783          	ld	a5,-1300(a5) # 1528 <stacks>
 a44:	97ba                	add	a5,a5,a4
 a46:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a48:	00000697          	auipc	a3,0x0
 a4c:	e9468693          	addi	a3,a3,-364 # 8dc <ithread_exit>
 a50:	862a                	mv	a2,a0
 a52:	85ce                	mv	a1,s3
 a54:	854a                	mv	a0,s2
 a56:	00000097          	auipc	ra,0x0
 a5a:	9f2080e7          	jalr	-1550(ra) # 448 <create_thread>
 a5e:	892a                	mv	s2,a0
  if (res != -1) {
 a60:	57fd                	li	a5,-1
 a62:	04f50d63          	beq	a0,a5,abc <ithread_create+0xd6>
    num_threads++;
 a66:	00001717          	auipc	a4,0x1
 a6a:	aca70713          	addi	a4,a4,-1334 # 1530 <num_threads>
 a6e:	431c                	lw	a5,0(a4)
 a70:	2785                	addiw	a5,a5,1
 a72:	c31c                	sw	a5,0(a4)
 a74:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a76:	854a                	mv	a0,s2
 a78:	70a2                	ld	ra,40(sp)
 a7a:	7402                	ld	s0,32(sp)
 a7c:	6942                	ld	s2,16(sp)
 a7e:	69a2                	ld	s3,8(sp)
 a80:	6145                	addi	sp,sp,48
 a82:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a84:	00001517          	auipc	a0,0x1
 a88:	a7c52503          	lw	a0,-1412(a0) # 1500 <max_stacks>
 a8c:	0035151b          	slliw	a0,a0,0x3
 a90:	00000097          	auipc	ra,0x0
 a94:	d52080e7          	jalr	-686(ra) # 7e2 <malloc>
 a98:	00001797          	auipc	a5,0x1
 a9c:	a8a7b823          	sd	a0,-1392(a5) # 1528 <stacks>
 aa0:	b785                	j	a00 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 aa2:	00000517          	auipc	a0,0x0
 aa6:	10e50513          	addi	a0,a0,270 # bb0 <ithread_join+0xce>
 aaa:	00000097          	auipc	ra,0x0
 aae:	c7c080e7          	jalr	-900(ra) # 726 <printf>
      return -1;
 ab2:	57fd                	li	a5,-1
 ab4:	893e                	mv	s2,a5
 ab6:	b7c1                	j	a76 <ithread_create+0x90>
 ab8:	ec26                	sd	s1,24(sp)
 aba:	b7b5                	j	a26 <ithread_create+0x40>
    free(stack_ptr);
 abc:	8526                	mv	a0,s1
 abe:	00000097          	auipc	ra,0x0
 ac2:	c9e080e7          	jalr	-866(ra) # 75c <free>
    stacks[num_threads] = 0;
 ac6:	00001717          	auipc	a4,0x1
 aca:	a6a72703          	lw	a4,-1430(a4) # 1530 <num_threads>
 ace:	070e                	slli	a4,a4,0x3
 ad0:	00001797          	auipc	a5,0x1
 ad4:	a587b783          	ld	a5,-1448(a5) # 1528 <stacks>
 ad8:	97ba                	add	a5,a5,a4
 ada:	0007b023          	sd	zero,0(a5)
 ade:	64e2                	ld	s1,24(sp)
 ae0:	bf59                	j	a76 <ithread_create+0x90>

0000000000000ae2 <ithread_join>:

int ithread_join(int thread_id) {
 ae2:	1101                	addi	sp,sp,-32
 ae4:	ec06                	sd	ra,24(sp)
 ae6:	e822                	sd	s0,16(sp)
 ae8:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 aea:	fec40593          	addi	a1,s0,-20
 aee:	00000097          	auipc	ra,0x0
 af2:	962080e7          	jalr	-1694(ra) # 450 <join_thread>
  threads_done++;
 af6:	00001717          	auipc	a4,0x1
 afa:	a3e70713          	addi	a4,a4,-1474 # 1534 <threads_done>
 afe:	431c                	lw	a5,0(a4)
 b00:	2785                	addiw	a5,a5,1
 b02:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b04:	00001717          	auipc	a4,0x1
 b08:	a2c72703          	lw	a4,-1492(a4) # 1530 <num_threads>
 b0c:	00f70863          	beq	a4,a5,b1c <ithread_join+0x3a>
    free_stacks();
  }
  return status;
}
 b10:	fec42503          	lw	a0,-20(s0)
 b14:	60e2                	ld	ra,24(sp)
 b16:	6442                	ld	s0,16(sp)
 b18:	6105                	addi	sp,sp,32
 b1a:	8082                	ret
    free_stacks();
 b1c:	00000097          	auipc	ra,0x0
 b20:	dd8080e7          	jalr	-552(ra) # 8f4 <free_stacks>
 b24:	b7f5                	j	b10 <ithread_join+0x2e>
