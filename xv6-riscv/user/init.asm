
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
  12:	b5250513          	addi	a0,a0,-1198 # b60 <ithread_join+0x54>
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
  3a:	b3290913          	addi	s2,s2,-1230 # b68 <ithread_join+0x5c>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	70e080e7          	jalr	1806(ra) # 74e <printf>
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
  6e:	b4e50513          	addi	a0,a0,-1202 # bb8 <ithread_join+0xac>
  72:	00000097          	auipc	ra,0x0
  76:	6dc080e7          	jalr	1756(ra) # 74e <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	324080e7          	jalr	804(ra) # 3a0 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	ad850513          	addi	a0,a0,-1320 # b60 <ithread_join+0x54>
  90:	00000097          	auipc	ra,0x0
  94:	358080e7          	jalr	856(ra) # 3e8 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	ac650513          	addi	a0,a0,-1338 # b60 <ithread_join+0x54>
  a2:	00000097          	auipc	ra,0x0
  a6:	33e080e7          	jalr	830(ra) # 3e0 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	ad450513          	addi	a0,a0,-1324 # b80 <ithread_join+0x74>
  b4:	00000097          	auipc	ra,0x0
  b8:	69a080e7          	jalr	1690(ra) # 74e <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2e2080e7          	jalr	738(ra) # 3a0 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	44a58593          	addi	a1,a1,1098 # 1510 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	aca50513          	addi	a0,a0,-1334 # b98 <ithread_join+0x8c>
  d6:	00000097          	auipc	ra,0x0
  da:	302080e7          	jalr	770(ra) # 3d8 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	ac250513          	addi	a0,a0,-1342 # ba0 <ithread_join+0x94>
  e6:	00000097          	auipc	ra,0x0
  ea:	668080e7          	jalr	1640(ra) # 74e <printf>
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

0000000000000460 <socket>:
.global socket
socket:
 li a7, SYS_socket
 460:	48e9                	li	a7,26
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <bind>:
.global bind
bind:
 li a7, SYS_bind
 468:	48ed                	li	a7,27
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <accept>:
.global accept
accept:
 li a7, SYS_accept
 470:	48f5                	li	a7,29
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <listen>:
.global listen
listen:
 li a7, SYS_listen
 478:	48f1                	li	a7,28
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <connect>:
.global connect
connect:
 li a7, SYS_connect
 480:	48f9                	li	a7,30
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 488:	1101                	addi	sp,sp,-32
 48a:	ec06                	sd	ra,24(sp)
 48c:	e822                	sd	s0,16(sp)
 48e:	1000                	addi	s0,sp,32
 490:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 494:	4605                	li	a2,1
 496:	fef40593          	addi	a1,s0,-17
 49a:	00000097          	auipc	ra,0x0
 49e:	f26080e7          	jalr	-218(ra) # 3c0 <write>
}
 4a2:	60e2                	ld	ra,24(sp)
 4a4:	6442                	ld	s0,16(sp)
 4a6:	6105                	addi	sp,sp,32
 4a8:	8082                	ret

00000000000004aa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4aa:	7139                	addi	sp,sp,-64
 4ac:	fc06                	sd	ra,56(sp)
 4ae:	f822                	sd	s0,48(sp)
 4b0:	f04a                	sd	s2,32(sp)
 4b2:	ec4e                	sd	s3,24(sp)
 4b4:	0080                	addi	s0,sp,64
 4b6:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b8:	cad9                	beqz	a3,54e <printint+0xa4>
 4ba:	01f5d79b          	srliw	a5,a1,0x1f
 4be:	cbc1                	beqz	a5,54e <printint+0xa4>
    neg = 1;
    x = -xx;
 4c0:	40b005bb          	negw	a1,a1
    neg = 1;
 4c4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4c6:	fc040993          	addi	s3,s0,-64
  neg = 0;
 4ca:	86ce                	mv	a3,s3
  i = 0;
 4cc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ce:	00000817          	auipc	a6,0x0
 4d2:	79a80813          	addi	a6,a6,1946 # c68 <digits>
 4d6:	88ba                	mv	a7,a4
 4d8:	0017051b          	addiw	a0,a4,1
 4dc:	872a                	mv	a4,a0
 4de:	02c5f7bb          	remuw	a5,a1,a2
 4e2:	1782                	slli	a5,a5,0x20
 4e4:	9381                	srli	a5,a5,0x20
 4e6:	97c2                	add	a5,a5,a6
 4e8:	0007c783          	lbu	a5,0(a5)
 4ec:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4f0:	87ae                	mv	a5,a1
 4f2:	02c5d5bb          	divuw	a1,a1,a2
 4f6:	0685                	addi	a3,a3,1
 4f8:	fcc7ffe3          	bgeu	a5,a2,4d6 <printint+0x2c>
  if(neg)
 4fc:	00030c63          	beqz	t1,514 <printint+0x6a>
    buf[i++] = '-';
 500:	fd050793          	addi	a5,a0,-48
 504:	00878533          	add	a0,a5,s0
 508:	02d00793          	li	a5,45
 50c:	fef50823          	sb	a5,-16(a0)
 510:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 514:	02e05763          	blez	a4,542 <printint+0x98>
 518:	f426                	sd	s1,40(sp)
 51a:	377d                	addiw	a4,a4,-1
 51c:	00e984b3          	add	s1,s3,a4
 520:	19fd                	addi	s3,s3,-1
 522:	99ba                	add	s3,s3,a4
 524:	1702                	slli	a4,a4,0x20
 526:	9301                	srli	a4,a4,0x20
 528:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 52c:	0004c583          	lbu	a1,0(s1)
 530:	854a                	mv	a0,s2
 532:	00000097          	auipc	ra,0x0
 536:	f56080e7          	jalr	-170(ra) # 488 <putc>
  while(--i >= 0)
 53a:	14fd                	addi	s1,s1,-1
 53c:	ff3498e3          	bne	s1,s3,52c <printint+0x82>
 540:	74a2                	ld	s1,40(sp)
}
 542:	70e2                	ld	ra,56(sp)
 544:	7442                	ld	s0,48(sp)
 546:	7902                	ld	s2,32(sp)
 548:	69e2                	ld	s3,24(sp)
 54a:	6121                	addi	sp,sp,64
 54c:	8082                	ret
  neg = 0;
 54e:	4301                	li	t1,0
 550:	bf9d                	j	4c6 <printint+0x1c>

0000000000000552 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 552:	715d                	addi	sp,sp,-80
 554:	e486                	sd	ra,72(sp)
 556:	e0a2                	sd	s0,64(sp)
 558:	f84a                	sd	s2,48(sp)
 55a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 55c:	0005c903          	lbu	s2,0(a1)
 560:	1a090b63          	beqz	s2,716 <vprintf+0x1c4>
 564:	fc26                	sd	s1,56(sp)
 566:	f44e                	sd	s3,40(sp)
 568:	f052                	sd	s4,32(sp)
 56a:	ec56                	sd	s5,24(sp)
 56c:	e85a                	sd	s6,16(sp)
 56e:	e45e                	sd	s7,8(sp)
 570:	8aaa                	mv	s5,a0
 572:	8bb2                	mv	s7,a2
 574:	00158493          	addi	s1,a1,1
  state = 0;
 578:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 57a:	02500a13          	li	s4,37
 57e:	4b55                	li	s6,21
 580:	a839                	j	59e <vprintf+0x4c>
        putc(fd, c);
 582:	85ca                	mv	a1,s2
 584:	8556                	mv	a0,s5
 586:	00000097          	auipc	ra,0x0
 58a:	f02080e7          	jalr	-254(ra) # 488 <putc>
 58e:	a019                	j	594 <vprintf+0x42>
    } else if(state == '%'){
 590:	01498d63          	beq	s3,s4,5aa <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 594:	0485                	addi	s1,s1,1
 596:	fff4c903          	lbu	s2,-1(s1)
 59a:	16090863          	beqz	s2,70a <vprintf+0x1b8>
    if(state == 0){
 59e:	fe0999e3          	bnez	s3,590 <vprintf+0x3e>
      if(c == '%'){
 5a2:	ff4910e3          	bne	s2,s4,582 <vprintf+0x30>
        state = '%';
 5a6:	89d2                	mv	s3,s4
 5a8:	b7f5                	j	594 <vprintf+0x42>
      if(c == 'd'){
 5aa:	13490563          	beq	s2,s4,6d4 <vprintf+0x182>
 5ae:	f9d9079b          	addiw	a5,s2,-99
 5b2:	0ff7f793          	zext.b	a5,a5
 5b6:	12fb6863          	bltu	s6,a5,6e6 <vprintf+0x194>
 5ba:	f9d9079b          	addiw	a5,s2,-99
 5be:	0ff7f713          	zext.b	a4,a5
 5c2:	12eb6263          	bltu	s6,a4,6e6 <vprintf+0x194>
 5c6:	00271793          	slli	a5,a4,0x2
 5ca:	00000717          	auipc	a4,0x0
 5ce:	64670713          	addi	a4,a4,1606 # c10 <ithread_join+0x104>
 5d2:	97ba                	add	a5,a5,a4
 5d4:	439c                	lw	a5,0(a5)
 5d6:	97ba                	add	a5,a5,a4
 5d8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5da:	008b8913          	addi	s2,s7,8
 5de:	4685                	li	a3,1
 5e0:	4629                	li	a2,10
 5e2:	000ba583          	lw	a1,0(s7)
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	ec2080e7          	jalr	-318(ra) # 4aa <printint>
 5f0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5f2:	4981                	li	s3,0
 5f4:	b745                	j	594 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	4681                	li	a3,0
 5fc:	4629                	li	a2,10
 5fe:	000ba583          	lw	a1,0(s7)
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	ea6080e7          	jalr	-346(ra) # 4aa <printint>
 60c:	8bca                	mv	s7,s2
      state = 0;
 60e:	4981                	li	s3,0
 610:	b751                	j	594 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 612:	008b8913          	addi	s2,s7,8
 616:	4681                	li	a3,0
 618:	4641                	li	a2,16
 61a:	000ba583          	lw	a1,0(s7)
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e8a080e7          	jalr	-374(ra) # 4aa <printint>
 628:	8bca                	mv	s7,s2
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b7a5                	j	594 <vprintf+0x42>
 62e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 630:	008b8793          	addi	a5,s7,8
 634:	8c3e                	mv	s8,a5
 636:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 63a:	03000593          	li	a1,48
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	e48080e7          	jalr	-440(ra) # 488 <putc>
  putc(fd, 'x');
 648:	07800593          	li	a1,120
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	e3a080e7          	jalr	-454(ra) # 488 <putc>
 656:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 658:	00000b97          	auipc	s7,0x0
 65c:	610b8b93          	addi	s7,s7,1552 # c68 <digits>
 660:	03c9d793          	srli	a5,s3,0x3c
 664:	97de                	add	a5,a5,s7
 666:	0007c583          	lbu	a1,0(a5)
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	e1c080e7          	jalr	-484(ra) # 488 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 674:	0992                	slli	s3,s3,0x4
 676:	397d                	addiw	s2,s2,-1
 678:	fe0914e3          	bnez	s2,660 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 67c:	8be2                	mv	s7,s8
      state = 0;
 67e:	4981                	li	s3,0
 680:	6c02                	ld	s8,0(sp)
 682:	bf09                	j	594 <vprintf+0x42>
        s = va_arg(ap, char*);
 684:	008b8993          	addi	s3,s7,8
 688:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 68c:	02090163          	beqz	s2,6ae <vprintf+0x15c>
        while(*s != 0){
 690:	00094583          	lbu	a1,0(s2)
 694:	c9a5                	beqz	a1,704 <vprintf+0x1b2>
          putc(fd, *s);
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	df0080e7          	jalr	-528(ra) # 488 <putc>
          s++;
 6a0:	0905                	addi	s2,s2,1
        while(*s != 0){
 6a2:	00094583          	lbu	a1,0(s2)
 6a6:	f9e5                	bnez	a1,696 <vprintf+0x144>
        s = va_arg(ap, char*);
 6a8:	8bce                	mv	s7,s3
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	b5e5                	j	594 <vprintf+0x42>
          s = "(null)";
 6ae:	00000917          	auipc	s2,0x0
 6b2:	52a90913          	addi	s2,s2,1322 # bd8 <ithread_join+0xcc>
        while(*s != 0){
 6b6:	02800593          	li	a1,40
 6ba:	bff1                	j	696 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 6bc:	008b8913          	addi	s2,s7,8
 6c0:	000bc583          	lbu	a1,0(s7)
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	dc2080e7          	jalr	-574(ra) # 488 <putc>
 6ce:	8bca                	mv	s7,s2
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b5c9                	j	594 <vprintf+0x42>
        putc(fd, c);
 6d4:	02500593          	li	a1,37
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	dae080e7          	jalr	-594(ra) # 488 <putc>
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	bd45                	j	594 <vprintf+0x42>
        putc(fd, '%');
 6e6:	02500593          	li	a1,37
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	d9c080e7          	jalr	-612(ra) # 488 <putc>
        putc(fd, c);
 6f4:	85ca                	mv	a1,s2
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	d90080e7          	jalr	-624(ra) # 488 <putc>
      state = 0;
 700:	4981                	li	s3,0
 702:	bd49                	j	594 <vprintf+0x42>
        s = va_arg(ap, char*);
 704:	8bce                	mv	s7,s3
      state = 0;
 706:	4981                	li	s3,0
 708:	b571                	j	594 <vprintf+0x42>
 70a:	74e2                	ld	s1,56(sp)
 70c:	79a2                	ld	s3,40(sp)
 70e:	7a02                	ld	s4,32(sp)
 710:	6ae2                	ld	s5,24(sp)
 712:	6b42                	ld	s6,16(sp)
 714:	6ba2                	ld	s7,8(sp)
    }
  }
}
 716:	60a6                	ld	ra,72(sp)
 718:	6406                	ld	s0,64(sp)
 71a:	7942                	ld	s2,48(sp)
 71c:	6161                	addi	sp,sp,80
 71e:	8082                	ret

0000000000000720 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 720:	715d                	addi	sp,sp,-80
 722:	ec06                	sd	ra,24(sp)
 724:	e822                	sd	s0,16(sp)
 726:	1000                	addi	s0,sp,32
 728:	e010                	sd	a2,0(s0)
 72a:	e414                	sd	a3,8(s0)
 72c:	e818                	sd	a4,16(s0)
 72e:	ec1c                	sd	a5,24(s0)
 730:	03043023          	sd	a6,32(s0)
 734:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 738:	8622                	mv	a2,s0
 73a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73e:	00000097          	auipc	ra,0x0
 742:	e14080e7          	jalr	-492(ra) # 552 <vprintf>
}
 746:	60e2                	ld	ra,24(sp)
 748:	6442                	ld	s0,16(sp)
 74a:	6161                	addi	sp,sp,80
 74c:	8082                	ret

000000000000074e <printf>:

void
printf(const char *fmt, ...)
{
 74e:	711d                	addi	sp,sp,-96
 750:	ec06                	sd	ra,24(sp)
 752:	e822                	sd	s0,16(sp)
 754:	1000                	addi	s0,sp,32
 756:	e40c                	sd	a1,8(s0)
 758:	e810                	sd	a2,16(s0)
 75a:	ec14                	sd	a3,24(s0)
 75c:	f018                	sd	a4,32(s0)
 75e:	f41c                	sd	a5,40(s0)
 760:	03043823          	sd	a6,48(s0)
 764:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 768:	00840613          	addi	a2,s0,8
 76c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 770:	85aa                	mv	a1,a0
 772:	4505                	li	a0,1
 774:	00000097          	auipc	ra,0x0
 778:	dde080e7          	jalr	-546(ra) # 552 <vprintf>
}
 77c:	60e2                	ld	ra,24(sp)
 77e:	6442                	ld	s0,16(sp)
 780:	6125                	addi	sp,sp,96
 782:	8082                	ret

0000000000000784 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 784:	1141                	addi	sp,sp,-16
 786:	e406                	sd	ra,8(sp)
 788:	e022                	sd	s0,0(sp)
 78a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 790:	00001797          	auipc	a5,0x1
 794:	d907b783          	ld	a5,-624(a5) # 1520 <freep>
 798:	a039                	j	7a6 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79a:	6398                	ld	a4,0(a5)
 79c:	00e7e463          	bltu	a5,a4,7a4 <free+0x20>
 7a0:	00e6ea63          	bltu	a3,a4,7b4 <free+0x30>
{
 7a4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a6:	fed7fae3          	bgeu	a5,a3,79a <free+0x16>
 7aa:	6398                	ld	a4,0(a5)
 7ac:	00e6e463          	bltu	a3,a4,7b4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b0:	fee7eae3          	bltu	a5,a4,7a4 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b4:	ff852583          	lw	a1,-8(a0)
 7b8:	6390                	ld	a2,0(a5)
 7ba:	02059813          	slli	a6,a1,0x20
 7be:	01c85713          	srli	a4,a6,0x1c
 7c2:	9736                	add	a4,a4,a3
 7c4:	02e60563          	beq	a2,a4,7ee <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7c8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7cc:	4790                	lw	a2,8(a5)
 7ce:	02061593          	slli	a1,a2,0x20
 7d2:	01c5d713          	srli	a4,a1,0x1c
 7d6:	973e                	add	a4,a4,a5
 7d8:	02e68263          	beq	a3,a4,7fc <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7dc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7de:	00001717          	auipc	a4,0x1
 7e2:	d4f73123          	sd	a5,-702(a4) # 1520 <freep>
}
 7e6:	60a2                	ld	ra,8(sp)
 7e8:	6402                	ld	s0,0(sp)
 7ea:	0141                	addi	sp,sp,16
 7ec:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7ee:	4618                	lw	a4,8(a2)
 7f0:	9f2d                	addw	a4,a4,a1
 7f2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	6398                	ld	a4,0(a5)
 7f8:	6310                	ld	a2,0(a4)
 7fa:	b7f9                	j	7c8 <free+0x44>
    p->s.size += bp->s.size;
 7fc:	ff852703          	lw	a4,-8(a0)
 800:	9f31                	addw	a4,a4,a2
 802:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 804:	ff053683          	ld	a3,-16(a0)
 808:	bfd1                	j	7dc <free+0x58>

000000000000080a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 80a:	7139                	addi	sp,sp,-64
 80c:	fc06                	sd	ra,56(sp)
 80e:	f822                	sd	s0,48(sp)
 810:	f04a                	sd	s2,32(sp)
 812:	ec4e                	sd	s3,24(sp)
 814:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 816:	02051993          	slli	s3,a0,0x20
 81a:	0209d993          	srli	s3,s3,0x20
 81e:	09bd                	addi	s3,s3,15
 820:	0049d993          	srli	s3,s3,0x4
 824:	2985                	addiw	s3,s3,1
 826:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 828:	00001517          	auipc	a0,0x1
 82c:	cf853503          	ld	a0,-776(a0) # 1520 <freep>
 830:	c905                	beqz	a0,860 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 832:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 834:	4798                	lw	a4,8(a5)
 836:	09377a63          	bgeu	a4,s3,8ca <malloc+0xc0>
 83a:	f426                	sd	s1,40(sp)
 83c:	e852                	sd	s4,16(sp)
 83e:	e456                	sd	s5,8(sp)
 840:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 842:	8a4e                	mv	s4,s3
 844:	6705                	lui	a4,0x1
 846:	00e9f363          	bgeu	s3,a4,84c <malloc+0x42>
 84a:	6a05                	lui	s4,0x1
 84c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 850:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 854:	00001497          	auipc	s1,0x1
 858:	ccc48493          	addi	s1,s1,-820 # 1520 <freep>
  if(p == (char*)-1)
 85c:	5afd                	li	s5,-1
 85e:	a089                	j	8a0 <malloc+0x96>
 860:	f426                	sd	s1,40(sp)
 862:	e852                	sd	s4,16(sp)
 864:	e456                	sd	s5,8(sp)
 866:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 868:	00001797          	auipc	a5,0x1
 86c:	cd878793          	addi	a5,a5,-808 # 1540 <base>
 870:	00001717          	auipc	a4,0x1
 874:	caf73823          	sd	a5,-848(a4) # 1520 <freep>
 878:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 87a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 87e:	b7d1                	j	842 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 880:	6398                	ld	a4,0(a5)
 882:	e118                	sd	a4,0(a0)
 884:	a8b9                	j	8e2 <malloc+0xd8>
  hp->s.size = nu;
 886:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88a:	0541                	addi	a0,a0,16
 88c:	00000097          	auipc	ra,0x0
 890:	ef8080e7          	jalr	-264(ra) # 784 <free>
  return freep;
 894:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 896:	c135                	beqz	a0,8fa <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 898:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89a:	4798                	lw	a4,8(a5)
 89c:	03277363          	bgeu	a4,s2,8c2 <malloc+0xb8>
    if(p == freep)
 8a0:	6098                	ld	a4,0(s1)
 8a2:	853e                	mv	a0,a5
 8a4:	fef71ae3          	bne	a4,a5,898 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8a8:	8552                	mv	a0,s4
 8aa:	00000097          	auipc	ra,0x0
 8ae:	b7e080e7          	jalr	-1154(ra) # 428 <sbrk>
  if(p == (char*)-1)
 8b2:	fd551ae3          	bne	a0,s5,886 <malloc+0x7c>
        return 0;
 8b6:	4501                	li	a0,0
 8b8:	74a2                	ld	s1,40(sp)
 8ba:	6a42                	ld	s4,16(sp)
 8bc:	6aa2                	ld	s5,8(sp)
 8be:	6b02                	ld	s6,0(sp)
 8c0:	a03d                	j	8ee <malloc+0xe4>
 8c2:	74a2                	ld	s1,40(sp)
 8c4:	6a42                	ld	s4,16(sp)
 8c6:	6aa2                	ld	s5,8(sp)
 8c8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ca:	fae90be3          	beq	s2,a4,880 <malloc+0x76>
        p->s.size -= nunits;
 8ce:	4137073b          	subw	a4,a4,s3
 8d2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d4:	02071693          	slli	a3,a4,0x20
 8d8:	01c6d713          	srli	a4,a3,0x1c
 8dc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8de:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e2:	00001717          	auipc	a4,0x1
 8e6:	c2a73f23          	sd	a0,-962(a4) # 1520 <freep>
      return (void*)(p + 1);
 8ea:	01078513          	addi	a0,a5,16
  }
}
 8ee:	70e2                	ld	ra,56(sp)
 8f0:	7442                	ld	s0,48(sp)
 8f2:	7902                	ld	s2,32(sp)
 8f4:	69e2                	ld	s3,24(sp)
 8f6:	6121                	addi	sp,sp,64
 8f8:	8082                	ret
 8fa:	74a2                	ld	s1,40(sp)
 8fc:	6a42                	ld	s4,16(sp)
 8fe:	6aa2                	ld	s5,8(sp)
 900:	6b02                	ld	s6,0(sp)
 902:	b7f5                	j	8ee <malloc+0xe4>

0000000000000904 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 904:	1141                	addi	sp,sp,-16
 906:	e406                	sd	ra,8(sp)
 908:	e022                	sd	s0,0(sp)
 90a:	0800                	addi	s0,sp,16
  thread_exit(status);
 90c:	2501                	sext.w	a0,a0
 90e:	00000097          	auipc	ra,0x0
 912:	b4a080e7          	jalr	-1206(ra) # 458 <thread_exit>
}
 916:	60a2                	ld	ra,8(sp)
 918:	6402                	ld	s0,0(sp)
 91a:	0141                	addi	sp,sp,16
 91c:	8082                	ret

000000000000091e <free_stacks>:
int free_stacks() {
 91e:	7179                	addi	sp,sp,-48
 920:	f406                	sd	ra,40(sp)
 922:	f022                	sd	s0,32(sp)
 924:	ec26                	sd	s1,24(sp)
 926:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 928:	00001797          	auipc	a5,0x1
 92c:	c087a783          	lw	a5,-1016(a5) # 1530 <num_threads>
 930:	04f05063          	blez	a5,970 <free_stacks+0x52>
 934:	e84a                	sd	s2,16(sp)
 936:	e44e                	sd	s3,8(sp)
 938:	4481                	li	s1,0
    free(stacks[i]);
 93a:	00001997          	auipc	s3,0x1
 93e:	bee98993          	addi	s3,s3,-1042 # 1528 <stacks>
  for (int i = 0; i < num_threads; i++) {
 942:	00001917          	auipc	s2,0x1
 946:	bee90913          	addi	s2,s2,-1042 # 1530 <num_threads>
    free(stacks[i]);
 94a:	0009b783          	ld	a5,0(s3)
 94e:	00349713          	slli	a4,s1,0x3
 952:	97ba                	add	a5,a5,a4
 954:	6388                	ld	a0,0(a5)
 956:	00000097          	auipc	ra,0x0
 95a:	e2e080e7          	jalr	-466(ra) # 784 <free>
  for (int i = 0; i < num_threads; i++) {
 95e:	0485                	addi	s1,s1,1
 960:	00092703          	lw	a4,0(s2)
 964:	0004879b          	sext.w	a5,s1
 968:	fee7c1e3          	blt	a5,a4,94a <free_stacks+0x2c>
 96c:	6942                	ld	s2,16(sp)
 96e:	69a2                	ld	s3,8(sp)
  free(stacks);
 970:	00001497          	auipc	s1,0x1
 974:	bb848493          	addi	s1,s1,-1096 # 1528 <stacks>
 978:	6088                	ld	a0,0(s1)
 97a:	00000097          	auipc	ra,0x0
 97e:	e0a080e7          	jalr	-502(ra) # 784 <free>
  stacks = 0;
 982:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 986:	00001797          	auipc	a5,0x1
 98a:	ba07a523          	sw	zero,-1110(a5) # 1530 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 98e:	47a1                	li	a5,8
 990:	00001717          	auipc	a4,0x1
 994:	b6f72823          	sw	a5,-1168(a4) # 1500 <max_stacks>
  threads_done = 0;
 998:	00001797          	auipc	a5,0x1
 99c:	b807ae23          	sw	zero,-1124(a5) # 1534 <threads_done>
}
 9a0:	4501                	li	a0,0
 9a2:	70a2                	ld	ra,40(sp)
 9a4:	7402                	ld	s0,32(sp)
 9a6:	64e2                	ld	s1,24(sp)
 9a8:	6145                	addi	sp,sp,48
 9aa:	8082                	ret

00000000000009ac <expand_num_threads>:
int expand_num_threads() {
 9ac:	1101                	addi	sp,sp,-32
 9ae:	ec06                	sd	ra,24(sp)
 9b0:	e822                	sd	s0,16(sp)
 9b2:	e426                	sd	s1,8(sp)
 9b4:	e04a                	sd	s2,0(sp)
 9b6:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 9b8:	00001797          	auipc	a5,0x1
 9bc:	b4878793          	addi	a5,a5,-1208 # 1500 <max_stacks>
 9c0:	4388                	lw	a0,0(a5)
 9c2:	0015151b          	slliw	a0,a0,0x1
 9c6:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 9c8:	0035151b          	slliw	a0,a0,0x3
 9cc:	00000097          	auipc	ra,0x0
 9d0:	e3e080e7          	jalr	-450(ra) # 80a <malloc>
 9d4:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 9d6:	00001617          	auipc	a2,0x1
 9da:	b5a62603          	lw	a2,-1190(a2) # 1530 <num_threads>
 9de:	00001497          	auipc	s1,0x1
 9e2:	b4a48493          	addi	s1,s1,-1206 # 1528 <stacks>
 9e6:	0036161b          	slliw	a2,a2,0x3
 9ea:	608c                	ld	a1,0(s1)
 9ec:	00000097          	auipc	ra,0x0
 9f0:	8fe080e7          	jalr	-1794(ra) # 2ea <memmove>
  free(stacks);
 9f4:	6088                	ld	a0,0(s1)
 9f6:	00000097          	auipc	ra,0x0
 9fa:	d8e080e7          	jalr	-626(ra) # 784 <free>
  stacks = new_stacks;
 9fe:	0124b023          	sd	s2,0(s1)
}
 a02:	4501                	li	a0,0
 a04:	60e2                	ld	ra,24(sp)
 a06:	6442                	ld	s0,16(sp)
 a08:	64a2                	ld	s1,8(sp)
 a0a:	6902                	ld	s2,0(sp)
 a0c:	6105                	addi	sp,sp,32
 a0e:	8082                	ret

0000000000000a10 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a10:	7179                	addi	sp,sp,-48
 a12:	f406                	sd	ra,40(sp)
 a14:	f022                	sd	s0,32(sp)
 a16:	e84a                	sd	s2,16(sp)
 a18:	e44e                	sd	s3,8(sp)
 a1a:	1800                	addi	s0,sp,48
 a1c:	892a                	mv	s2,a0
 a1e:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a20:	00001797          	auipc	a5,0x1
 a24:	b087b783          	ld	a5,-1272(a5) # 1528 <stacks>
 a28:	c3d9                	beqz	a5,aae <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a2a:	00001797          	auipc	a5,0x1
 a2e:	ad67a783          	lw	a5,-1322(a5) # 1500 <max_stacks>
 a32:	00001717          	auipc	a4,0x1
 a36:	afe72703          	lw	a4,-1282(a4) # 1530 <num_threads>
 a3a:	0af71463          	bne	a4,a5,ae2 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 a3e:	04000713          	li	a4,64
 a42:	08e78563          	beq	a5,a4,acc <ithread_create+0xbc>
 a46:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a48:	00000097          	auipc	ra,0x0
 a4c:	f64080e7          	jalr	-156(ra) # 9ac <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a50:	6505                	lui	a0,0x1
 a52:	00000097          	auipc	ra,0x0
 a56:	db8080e7          	jalr	-584(ra) # 80a <malloc>
 a5a:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a5c:	00001717          	auipc	a4,0x1
 a60:	ad472703          	lw	a4,-1324(a4) # 1530 <num_threads>
 a64:	070e                	slli	a4,a4,0x3
 a66:	00001797          	auipc	a5,0x1
 a6a:	ac27b783          	ld	a5,-1342(a5) # 1528 <stacks>
 a6e:	97ba                	add	a5,a5,a4
 a70:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a72:	00000697          	auipc	a3,0x0
 a76:	e9268693          	addi	a3,a3,-366 # 904 <ithread_exit>
 a7a:	862a                	mv	a2,a0
 a7c:	85ce                	mv	a1,s3
 a7e:	854a                	mv	a0,s2
 a80:	00000097          	auipc	ra,0x0
 a84:	9c8080e7          	jalr	-1592(ra) # 448 <create_thread>
 a88:	892a                	mv	s2,a0
  if (res != -1) {
 a8a:	57fd                	li	a5,-1
 a8c:	04f50d63          	beq	a0,a5,ae6 <ithread_create+0xd6>
    num_threads++;
 a90:	00001717          	auipc	a4,0x1
 a94:	aa070713          	addi	a4,a4,-1376 # 1530 <num_threads>
 a98:	431c                	lw	a5,0(a4)
 a9a:	2785                	addiw	a5,a5,1
 a9c:	c31c                	sw	a5,0(a4)
 a9e:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 aa0:	854a                	mv	a0,s2
 aa2:	70a2                	ld	ra,40(sp)
 aa4:	7402                	ld	s0,32(sp)
 aa6:	6942                	ld	s2,16(sp)
 aa8:	69a2                	ld	s3,8(sp)
 aaa:	6145                	addi	sp,sp,48
 aac:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 aae:	00001517          	auipc	a0,0x1
 ab2:	a5252503          	lw	a0,-1454(a0) # 1500 <max_stacks>
 ab6:	0035151b          	slliw	a0,a0,0x3
 aba:	00000097          	auipc	ra,0x0
 abe:	d50080e7          	jalr	-688(ra) # 80a <malloc>
 ac2:	00001797          	auipc	a5,0x1
 ac6:	a6a7b323          	sd	a0,-1434(a5) # 1528 <stacks>
 aca:	b785                	j	a2a <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 acc:	00000517          	auipc	a0,0x0
 ad0:	11450513          	addi	a0,a0,276 # be0 <ithread_join+0xd4>
 ad4:	00000097          	auipc	ra,0x0
 ad8:	c7a080e7          	jalr	-902(ra) # 74e <printf>
      return -1;
 adc:	57fd                	li	a5,-1
 ade:	893e                	mv	s2,a5
 ae0:	b7c1                	j	aa0 <ithread_create+0x90>
 ae2:	ec26                	sd	s1,24(sp)
 ae4:	b7b5                	j	a50 <ithread_create+0x40>
    free(stack_ptr);
 ae6:	8526                	mv	a0,s1
 ae8:	00000097          	auipc	ra,0x0
 aec:	c9c080e7          	jalr	-868(ra) # 784 <free>
    stacks[num_threads] = 0;
 af0:	00001717          	auipc	a4,0x1
 af4:	a4072703          	lw	a4,-1472(a4) # 1530 <num_threads>
 af8:	070e                	slli	a4,a4,0x3
 afa:	00001797          	auipc	a5,0x1
 afe:	a2e7b783          	ld	a5,-1490(a5) # 1528 <stacks>
 b02:	97ba                	add	a5,a5,a4
 b04:	0007b023          	sd	zero,0(a5)
 b08:	64e2                	ld	s1,24(sp)
 b0a:	bf59                	j	aa0 <ithread_create+0x90>

0000000000000b0c <ithread_join>:

int ithread_join(int thread_id) {
 b0c:	1101                	addi	sp,sp,-32
 b0e:	ec06                	sd	ra,24(sp)
 b10:	e822                	sd	s0,16(sp)
 b12:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b14:	ff040793          	addi	a5,s0,-16
 b18:	ffc7859b          	addiw	a1,a5,-4
 b1c:	00000097          	auipc	ra,0x0
 b20:	934080e7          	jalr	-1740(ra) # 450 <join_thread>
  threads_done++;
 b24:	00001717          	auipc	a4,0x1
 b28:	a1070713          	addi	a4,a4,-1520 # 1534 <threads_done>
 b2c:	431c                	lw	a5,0(a4)
 b2e:	2785                	addiw	a5,a5,1
 b30:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b32:	00001717          	auipc	a4,0x1
 b36:	9fe72703          	lw	a4,-1538(a4) # 1530 <num_threads>
 b3a:	00f70863          	beq	a4,a5,b4a <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 b3e:	fec42503          	lw	a0,-20(s0)
 b42:	60e2                	ld	ra,24(sp)
 b44:	6442                	ld	s0,16(sp)
 b46:	6105                	addi	sp,sp,32
 b48:	8082                	ret
    free_stacks();
 b4a:	00000097          	auipc	ra,0x0
 b4e:	dd4080e7          	jalr	-556(ra) # 91e <free_stacks>
 b52:	b7f5                	j	b3e <ithread_join+0x32>
