
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
  1a:	3dc080e7          	jalr	988(ra) # 3f2 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	406080e7          	jalr	1030(ra) # 42a <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3fc080e7          	jalr	1020(ra) # 42a <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	b3290913          	addi	s2,s2,-1230 # b68 <ithread_join+0x5c>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	710080e7          	jalr	1808(ra) # 750 <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	362080e7          	jalr	866(ra) # 3aa <fork>
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
  5e:	360080e7          	jalr	864(ra) # 3ba <wait>
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
  76:	6de080e7          	jalr	1758(ra) # 750 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	336080e7          	jalr	822(ra) # 3b2 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	ad850513          	addi	a0,a0,-1320 # b60 <ithread_join+0x54>
  90:	00000097          	auipc	ra,0x0
  94:	36a080e7          	jalr	874(ra) # 3fa <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	ac650513          	addi	a0,a0,-1338 # b60 <ithread_join+0x54>
  a2:	00000097          	auipc	ra,0x0
  a6:	350080e7          	jalr	848(ra) # 3f2 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	ad450513          	addi	a0,a0,-1324 # b80 <ithread_join+0x74>
  b4:	00000097          	auipc	ra,0x0
  b8:	69c080e7          	jalr	1692(ra) # 750 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2f4080e7          	jalr	756(ra) # 3b2 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	44a58593          	addi	a1,a1,1098 # 1510 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	aca50513          	addi	a0,a0,-1334 # b98 <ithread_join+0x8c>
  d6:	00000097          	auipc	ra,0x0
  da:	314080e7          	jalr	788(ra) # 3ea <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	ac250513          	addi	a0,a0,-1342 # ba0 <ithread_join+0x94>
  e6:	00000097          	auipc	ra,0x0
  ea:	66a080e7          	jalr	1642(ra) # 750 <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	2c2080e7          	jalr	706(ra) # 3b2 <exit>

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
 10e:	2a8080e7          	jalr	680(ra) # 3b2 <exit>

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
 16e:	cf99                	beqz	a5,18c <strlen+0x2a>
 170:	0505                	addi	a0,a0,1
 172:	87aa                	mv	a5,a0
 174:	86be                	mv	a3,a5
 176:	0785                	addi	a5,a5,1
 178:	fff7c703          	lbu	a4,-1(a5)
 17c:	ff65                	bnez	a4,174 <strlen+0x12>
 17e:	40a6853b          	subw	a0,a3,a0
 182:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 184:	60a2                	ld	ra,8(sp)
 186:	6402                	ld	s0,0(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for(n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfdd                	j	184 <strlen+0x22>

0000000000000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 198:	ca19                	beqz	a2,1ae <memset+0x1e>
 19a:	87aa                	mv	a5,a0
 19c:	1602                	slli	a2,a2,0x20
 19e:	9201                	srli	a2,a2,0x20
 1a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a8:	0785                	addi	a5,a5,1
 1aa:	fee79de3          	bne	a5,a4,1a4 <memset+0x14>
  }
  return dst;
}
 1ae:	60a2                	ld	ra,8(sp)
 1b0:	6402                	ld	s0,0(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strchr>:

char*
strchr(const char *s, char c)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e406                	sd	ra,8(sp)
 1ba:	e022                	sd	s0,0(sp)
 1bc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	cf81                	beqz	a5,1da <strchr+0x24>
    if(*s == c)
 1c4:	00f58763          	beq	a1,a5,1d2 <strchr+0x1c>
  for(; *s; s++)
 1c8:	0505                	addi	a0,a0,1
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	fbfd                	bnez	a5,1c4 <strchr+0xe>
      return (char*)s;
  return 0;
 1d0:	4501                	li	a0,0
}
 1d2:	60a2                	ld	ra,8(sp)
 1d4:	6402                	ld	s0,0(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfdd                	j	1d2 <strchr+0x1c>

00000000000001de <gets>:

char*
gets(char *buf, int max)
{
 1de:	7159                	addi	sp,sp,-112
 1e0:	f486                	sd	ra,104(sp)
 1e2:	f0a2                	sd	s0,96(sp)
 1e4:	eca6                	sd	s1,88(sp)
 1e6:	e8ca                	sd	s2,80(sp)
 1e8:	e4ce                	sd	s3,72(sp)
 1ea:	e0d2                	sd	s4,64(sp)
 1ec:	fc56                	sd	s5,56(sp)
 1ee:	f85a                	sd	s6,48(sp)
 1f0:	f45e                	sd	s7,40(sp)
 1f2:	f062                	sd	s8,32(sp)
 1f4:	ec66                	sd	s9,24(sp)
 1f6:	e86a                	sd	s10,16(sp)
 1f8:	1880                	addi	s0,sp,112
 1fa:	8caa                	mv	s9,a0
 1fc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fe:	892a                	mv	s2,a0
 200:	4481                	li	s1,0
    cc = read(0, &c, 1);
 202:	f9f40b13          	addi	s6,s0,-97
 206:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 208:	4ba9                	li	s7,10
 20a:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 20c:	8d26                	mv	s10,s1
 20e:	0014899b          	addiw	s3,s1,1
 212:	84ce                	mv	s1,s3
 214:	0349d763          	bge	s3,s4,242 <gets+0x64>
    cc = read(0, &c, 1);
 218:	8656                	mv	a2,s5
 21a:	85da                	mv	a1,s6
 21c:	4501                	li	a0,0
 21e:	00000097          	auipc	ra,0x0
 222:	1ac080e7          	jalr	428(ra) # 3ca <read>
    if(cc < 1)
 226:	00a05e63          	blez	a0,242 <gets+0x64>
    buf[i++] = c;
 22a:	f9f44783          	lbu	a5,-97(s0)
 22e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 232:	01778763          	beq	a5,s7,240 <gets+0x62>
 236:	0905                	addi	s2,s2,1
 238:	fd879ae3          	bne	a5,s8,20c <gets+0x2e>
    buf[i++] = c;
 23c:	8d4e                	mv	s10,s3
 23e:	a011                	j	242 <gets+0x64>
 240:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 242:	9d66                	add	s10,s10,s9
 244:	000d0023          	sb	zero,0(s10)
  return buf;
}
 248:	8566                	mv	a0,s9
 24a:	70a6                	ld	ra,104(sp)
 24c:	7406                	ld	s0,96(sp)
 24e:	64e6                	ld	s1,88(sp)
 250:	6946                	ld	s2,80(sp)
 252:	69a6                	ld	s3,72(sp)
 254:	6a06                	ld	s4,64(sp)
 256:	7ae2                	ld	s5,56(sp)
 258:	7b42                	ld	s6,48(sp)
 25a:	7ba2                	ld	s7,40(sp)
 25c:	7c02                	ld	s8,32(sp)
 25e:	6ce2                	ld	s9,24(sp)
 260:	6d42                	ld	s10,16(sp)
 262:	6165                	addi	sp,sp,112
 264:	8082                	ret

0000000000000266 <stat>:

int
stat(const char *n, struct stat *st)
{
 266:	1101                	addi	sp,sp,-32
 268:	ec06                	sd	ra,24(sp)
 26a:	e822                	sd	s0,16(sp)
 26c:	e04a                	sd	s2,0(sp)
 26e:	1000                	addi	s0,sp,32
 270:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 272:	4581                	li	a1,0
 274:	00000097          	auipc	ra,0x0
 278:	17e080e7          	jalr	382(ra) # 3f2 <open>
  if(fd < 0)
 27c:	02054663          	bltz	a0,2a8 <stat+0x42>
 280:	e426                	sd	s1,8(sp)
 282:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 284:	85ca                	mv	a1,s2
 286:	00000097          	auipc	ra,0x0
 28a:	184080e7          	jalr	388(ra) # 40a <fstat>
 28e:	892a                	mv	s2,a0
  close(fd);
 290:	8526                	mv	a0,s1
 292:	00000097          	auipc	ra,0x0
 296:	148080e7          	jalr	328(ra) # 3da <close>
  return r;
 29a:	64a2                	ld	s1,8(sp)
}
 29c:	854a                	mv	a0,s2
 29e:	60e2                	ld	ra,24(sp)
 2a0:	6442                	ld	s0,16(sp)
 2a2:	6902                	ld	s2,0(sp)
 2a4:	6105                	addi	sp,sp,32
 2a6:	8082                	ret
    return -1;
 2a8:	597d                	li	s2,-1
 2aa:	bfcd                	j	29c <stat+0x36>

00000000000002ac <atoi>:

int
atoi(const char *s)
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e406                	sd	ra,8(sp)
 2b0:	e022                	sd	s0,0(sp)
 2b2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b4:	00054683          	lbu	a3,0(a0)
 2b8:	fd06879b          	addiw	a5,a3,-48
 2bc:	0ff7f793          	zext.b	a5,a5
 2c0:	4625                	li	a2,9
 2c2:	02f66963          	bltu	a2,a5,2f4 <atoi+0x48>
 2c6:	872a                	mv	a4,a0
  n = 0;
 2c8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ca:	0705                	addi	a4,a4,1
 2cc:	0025179b          	slliw	a5,a0,0x2
 2d0:	9fa9                	addw	a5,a5,a0
 2d2:	0017979b          	slliw	a5,a5,0x1
 2d6:	9fb5                	addw	a5,a5,a3
 2d8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2dc:	00074683          	lbu	a3,0(a4)
 2e0:	fd06879b          	addiw	a5,a3,-48
 2e4:	0ff7f793          	zext.b	a5,a5
 2e8:	fef671e3          	bgeu	a2,a5,2ca <atoi+0x1e>
  return n;
}
 2ec:	60a2                	ld	ra,8(sp)
 2ee:	6402                	ld	s0,0(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret
  n = 0;
 2f4:	4501                	li	a0,0
 2f6:	bfdd                	j	2ec <atoi+0x40>

00000000000002f8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e406                	sd	ra,8(sp)
 2fc:	e022                	sd	s0,0(sp)
 2fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 300:	02b57563          	bgeu	a0,a1,32a <memmove+0x32>
    while(n-- > 0)
 304:	00c05f63          	blez	a2,322 <memmove+0x2a>
 308:	1602                	slli	a2,a2,0x20
 30a:	9201                	srli	a2,a2,0x20
 30c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 310:	872a                	mv	a4,a0
      *dst++ = *src++;
 312:	0585                	addi	a1,a1,1
 314:	0705                	addi	a4,a4,1
 316:	fff5c683          	lbu	a3,-1(a1)
 31a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 31e:	fee79ae3          	bne	a5,a4,312 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 322:	60a2                	ld	ra,8(sp)
 324:	6402                	ld	s0,0(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret
    dst += n;
 32a:	00c50733          	add	a4,a0,a2
    src += n;
 32e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 330:	fec059e3          	blez	a2,322 <memmove+0x2a>
 334:	fff6079b          	addiw	a5,a2,-1
 338:	1782                	slli	a5,a5,0x20
 33a:	9381                	srli	a5,a5,0x20
 33c:	fff7c793          	not	a5,a5
 340:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 342:	15fd                	addi	a1,a1,-1
 344:	177d                	addi	a4,a4,-1
 346:	0005c683          	lbu	a3,0(a1)
 34a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 34e:	fef71ae3          	bne	a4,a5,342 <memmove+0x4a>
 352:	bfc1                	j	322 <memmove+0x2a>

0000000000000354 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 35c:	ca0d                	beqz	a2,38e <memcmp+0x3a>
 35e:	fff6069b          	addiw	a3,a2,-1
 362:	1682                	slli	a3,a3,0x20
 364:	9281                	srli	a3,a3,0x20
 366:	0685                	addi	a3,a3,1
 368:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 36a:	00054783          	lbu	a5,0(a0)
 36e:	0005c703          	lbu	a4,0(a1)
 372:	00e79863          	bne	a5,a4,382 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 376:	0505                	addi	a0,a0,1
    p2++;
 378:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 37a:	fed518e3          	bne	a0,a3,36a <memcmp+0x16>
  }
  return 0;
 37e:	4501                	li	a0,0
 380:	a019                	j	386 <memcmp+0x32>
      return *p1 - *p2;
 382:	40e7853b          	subw	a0,a5,a4
}
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret
  return 0;
 38e:	4501                	li	a0,0
 390:	bfdd                	j	386 <memcmp+0x32>

0000000000000392 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 392:	1141                	addi	sp,sp,-16
 394:	e406                	sd	ra,8(sp)
 396:	e022                	sd	s0,0(sp)
 398:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 39a:	00000097          	auipc	ra,0x0
 39e:	f5e080e7          	jalr	-162(ra) # 2f8 <memmove>
}
 3a2:	60a2                	ld	ra,8(sp)
 3a4:	6402                	ld	s0,0(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret

00000000000003aa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3aa:	4885                	li	a7,1
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b2:	4889                	li	a7,2
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ba:	488d                	li	a7,3
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c2:	4891                	li	a7,4
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <read>:
.global read
read:
 li a7, SYS_read
 3ca:	4895                	li	a7,5
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <write>:
.global write
write:
 li a7, SYS_write
 3d2:	48c1                	li	a7,16
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <close>:
.global close
close:
 li a7, SYS_close
 3da:	48d5                	li	a7,21
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e2:	4899                	li	a7,6
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ea:	489d                	li	a7,7
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <open>:
.global open
open:
 li a7, SYS_open
 3f2:	48bd                	li	a7,15
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3fa:	48c5                	li	a7,17
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 402:	48c9                	li	a7,18
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 40a:	48a1                	li	a7,8
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <link>:
.global link
link:
 li a7, SYS_link
 412:	48cd                	li	a7,19
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 41a:	48d1                	li	a7,20
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 422:	48a5                	li	a7,9
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <dup>:
.global dup
dup:
 li a7, SYS_dup
 42a:	48a9                	li	a7,10
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 432:	48ad                	li	a7,11
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 43a:	48b1                	li	a7,12
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 442:	48b5                	li	a7,13
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 44a:	48b9                	li	a7,14
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 452:	48d9                	li	a7,22
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 45a:	48dd                	li	a7,23
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 462:	48e1                	li	a7,24
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 46a:	48e5                	li	a7,25
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <socket>:
.global socket
socket:
 li a7, SYS_socket
 472:	48e9                	li	a7,26
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <bind>:
.global bind
bind:
 li a7, SYS_bind
 47a:	48ed                	li	a7,27
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <accept>:
.global accept
accept:
 li a7, SYS_accept
 482:	48f5                	li	a7,29
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <listen>:
.global listen
listen:
 li a7, SYS_listen
 48a:	48f1                	li	a7,28
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <connect>:
.global connect
connect:
 li a7, SYS_connect
 492:	48f9                	li	a7,30
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 49a:	1101                	addi	sp,sp,-32
 49c:	ec06                	sd	ra,24(sp)
 49e:	e822                	sd	s0,16(sp)
 4a0:	1000                	addi	s0,sp,32
 4a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a6:	4605                	li	a2,1
 4a8:	fef40593          	addi	a1,s0,-17
 4ac:	00000097          	auipc	ra,0x0
 4b0:	f26080e7          	jalr	-218(ra) # 3d2 <write>
}
 4b4:	60e2                	ld	ra,24(sp)
 4b6:	6442                	ld	s0,16(sp)
 4b8:	6105                	addi	sp,sp,32
 4ba:	8082                	ret

00000000000004bc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4bc:	7139                	addi	sp,sp,-64
 4be:	fc06                	sd	ra,56(sp)
 4c0:	f822                	sd	s0,48(sp)
 4c2:	f426                	sd	s1,40(sp)
 4c4:	f04a                	sd	s2,32(sp)
 4c6:	ec4e                	sd	s3,24(sp)
 4c8:	0080                	addi	s0,sp,64
 4ca:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4cc:	c299                	beqz	a3,4d2 <printint+0x16>
 4ce:	0805c063          	bltz	a1,54e <printint+0x92>
  neg = 0;
 4d2:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4d4:	fc040313          	addi	t1,s0,-64
  neg = 0;
 4d8:	869a                	mv	a3,t1
  i = 0;
 4da:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4dc:	00000817          	auipc	a6,0x0
 4e0:	78c80813          	addi	a6,a6,1932 # c68 <digits>
 4e4:	88be                	mv	a7,a5
 4e6:	0017851b          	addiw	a0,a5,1
 4ea:	87aa                	mv	a5,a0
 4ec:	02c5f73b          	remuw	a4,a1,a2
 4f0:	1702                	slli	a4,a4,0x20
 4f2:	9301                	srli	a4,a4,0x20
 4f4:	9742                	add	a4,a4,a6
 4f6:	00074703          	lbu	a4,0(a4)
 4fa:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4fe:	872e                	mv	a4,a1
 500:	02c5d5bb          	divuw	a1,a1,a2
 504:	0685                	addi	a3,a3,1
 506:	fcc77fe3          	bgeu	a4,a2,4e4 <printint+0x28>
  if(neg)
 50a:	000e0c63          	beqz	t3,522 <printint+0x66>
    buf[i++] = '-';
 50e:	fd050793          	addi	a5,a0,-48
 512:	00878533          	add	a0,a5,s0
 516:	02d00793          	li	a5,45
 51a:	fef50823          	sb	a5,-16(a0)
 51e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 522:	fff7899b          	addiw	s3,a5,-1
 526:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 52a:	fff4c583          	lbu	a1,-1(s1)
 52e:	854a                	mv	a0,s2
 530:	00000097          	auipc	ra,0x0
 534:	f6a080e7          	jalr	-150(ra) # 49a <putc>
  while(--i >= 0)
 538:	39fd                	addiw	s3,s3,-1
 53a:	14fd                	addi	s1,s1,-1
 53c:	fe09d7e3          	bgez	s3,52a <printint+0x6e>
}
 540:	70e2                	ld	ra,56(sp)
 542:	7442                	ld	s0,48(sp)
 544:	74a2                	ld	s1,40(sp)
 546:	7902                	ld	s2,32(sp)
 548:	69e2                	ld	s3,24(sp)
 54a:	6121                	addi	sp,sp,64
 54c:	8082                	ret
    x = -xx;
 54e:	40b005bb          	negw	a1,a1
    neg = 1;
 552:	4e05                	li	t3,1
    x = -xx;
 554:	b741                	j	4d4 <printint+0x18>

0000000000000556 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 556:	715d                	addi	sp,sp,-80
 558:	e486                	sd	ra,72(sp)
 55a:	e0a2                	sd	s0,64(sp)
 55c:	f84a                	sd	s2,48(sp)
 55e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 560:	0005c903          	lbu	s2,0(a1)
 564:	1a090a63          	beqz	s2,718 <vprintf+0x1c2>
 568:	fc26                	sd	s1,56(sp)
 56a:	f44e                	sd	s3,40(sp)
 56c:	f052                	sd	s4,32(sp)
 56e:	ec56                	sd	s5,24(sp)
 570:	e85a                	sd	s6,16(sp)
 572:	e45e                	sd	s7,8(sp)
 574:	8aaa                	mv	s5,a0
 576:	8bb2                	mv	s7,a2
 578:	00158493          	addi	s1,a1,1
  state = 0;
 57c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 57e:	02500a13          	li	s4,37
 582:	4b55                	li	s6,21
 584:	a839                	j	5a2 <vprintf+0x4c>
        putc(fd, c);
 586:	85ca                	mv	a1,s2
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	f10080e7          	jalr	-240(ra) # 49a <putc>
 592:	a019                	j	598 <vprintf+0x42>
    } else if(state == '%'){
 594:	01498d63          	beq	s3,s4,5ae <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 598:	0485                	addi	s1,s1,1
 59a:	fff4c903          	lbu	s2,-1(s1)
 59e:	16090763          	beqz	s2,70c <vprintf+0x1b6>
    if(state == 0){
 5a2:	fe0999e3          	bnez	s3,594 <vprintf+0x3e>
      if(c == '%'){
 5a6:	ff4910e3          	bne	s2,s4,586 <vprintf+0x30>
        state = '%';
 5aa:	89d2                	mv	s3,s4
 5ac:	b7f5                	j	598 <vprintf+0x42>
      if(c == 'd'){
 5ae:	13490463          	beq	s2,s4,6d6 <vprintf+0x180>
 5b2:	f9d9079b          	addiw	a5,s2,-99
 5b6:	0ff7f793          	zext.b	a5,a5
 5ba:	12fb6763          	bltu	s6,a5,6e8 <vprintf+0x192>
 5be:	f9d9079b          	addiw	a5,s2,-99
 5c2:	0ff7f713          	zext.b	a4,a5
 5c6:	12eb6163          	bltu	s6,a4,6e8 <vprintf+0x192>
 5ca:	00271793          	slli	a5,a4,0x2
 5ce:	00000717          	auipc	a4,0x0
 5d2:	64270713          	addi	a4,a4,1602 # c10 <ithread_join+0x104>
 5d6:	97ba                	add	a5,a5,a4
 5d8:	439c                	lw	a5,0(a5)
 5da:	97ba                	add	a5,a5,a4
 5dc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5de:	008b8913          	addi	s2,s7,8
 5e2:	4685                	li	a3,1
 5e4:	4629                	li	a2,10
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	ed0080e7          	jalr	-304(ra) # 4bc <printint>
 5f4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b745                	j	598 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fa:	008b8913          	addi	s2,s7,8
 5fe:	4681                	li	a3,0
 600:	4629                	li	a2,10
 602:	000ba583          	lw	a1,0(s7)
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	eb4080e7          	jalr	-332(ra) # 4bc <printint>
 610:	8bca                	mv	s7,s2
      state = 0;
 612:	4981                	li	s3,0
 614:	b751                	j	598 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 616:	008b8913          	addi	s2,s7,8
 61a:	4681                	li	a3,0
 61c:	4641                	li	a2,16
 61e:	000ba583          	lw	a1,0(s7)
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	e98080e7          	jalr	-360(ra) # 4bc <printint>
 62c:	8bca                	mv	s7,s2
      state = 0;
 62e:	4981                	li	s3,0
 630:	b7a5                	j	598 <vprintf+0x42>
 632:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 634:	008b8c13          	addi	s8,s7,8
 638:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 63c:	03000593          	li	a1,48
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	e58080e7          	jalr	-424(ra) # 49a <putc>
  putc(fd, 'x');
 64a:	07800593          	li	a1,120
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	e4a080e7          	jalr	-438(ra) # 49a <putc>
 658:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65a:	00000b97          	auipc	s7,0x0
 65e:	60eb8b93          	addi	s7,s7,1550 # c68 <digits>
 662:	03c9d793          	srli	a5,s3,0x3c
 666:	97de                	add	a5,a5,s7
 668:	0007c583          	lbu	a1,0(a5)
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	e2c080e7          	jalr	-468(ra) # 49a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 676:	0992                	slli	s3,s3,0x4
 678:	397d                	addiw	s2,s2,-1
 67a:	fe0914e3          	bnez	s2,662 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 67e:	8be2                	mv	s7,s8
      state = 0;
 680:	4981                	li	s3,0
 682:	6c02                	ld	s8,0(sp)
 684:	bf11                	j	598 <vprintf+0x42>
        s = va_arg(ap, char*);
 686:	008b8993          	addi	s3,s7,8
 68a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 68e:	02090163          	beqz	s2,6b0 <vprintf+0x15a>
        while(*s != 0){
 692:	00094583          	lbu	a1,0(s2)
 696:	c9a5                	beqz	a1,706 <vprintf+0x1b0>
          putc(fd, *s);
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	e00080e7          	jalr	-512(ra) # 49a <putc>
          s++;
 6a2:	0905                	addi	s2,s2,1
        while(*s != 0){
 6a4:	00094583          	lbu	a1,0(s2)
 6a8:	f9e5                	bnez	a1,698 <vprintf+0x142>
        s = va_arg(ap, char*);
 6aa:	8bce                	mv	s7,s3
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	b5ed                	j	598 <vprintf+0x42>
          s = "(null)";
 6b0:	00000917          	auipc	s2,0x0
 6b4:	52890913          	addi	s2,s2,1320 # bd8 <ithread_join+0xcc>
        while(*s != 0){
 6b8:	02800593          	li	a1,40
 6bc:	bff1                	j	698 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6be:	008b8913          	addi	s2,s7,8
 6c2:	000bc583          	lbu	a1,0(s7)
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	dd2080e7          	jalr	-558(ra) # 49a <putc>
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b5d1                	j	598 <vprintf+0x42>
        putc(fd, c);
 6d6:	02500593          	li	a1,37
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	dbe080e7          	jalr	-578(ra) # 49a <putc>
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bd4d                	j	598 <vprintf+0x42>
        putc(fd, '%');
 6e8:	02500593          	li	a1,37
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	dac080e7          	jalr	-596(ra) # 49a <putc>
        putc(fd, c);
 6f6:	85ca                	mv	a1,s2
 6f8:	8556                	mv	a0,s5
 6fa:	00000097          	auipc	ra,0x0
 6fe:	da0080e7          	jalr	-608(ra) # 49a <putc>
      state = 0;
 702:	4981                	li	s3,0
 704:	bd51                	j	598 <vprintf+0x42>
        s = va_arg(ap, char*);
 706:	8bce                	mv	s7,s3
      state = 0;
 708:	4981                	li	s3,0
 70a:	b579                	j	598 <vprintf+0x42>
 70c:	74e2                	ld	s1,56(sp)
 70e:	79a2                	ld	s3,40(sp)
 710:	7a02                	ld	s4,32(sp)
 712:	6ae2                	ld	s5,24(sp)
 714:	6b42                	ld	s6,16(sp)
 716:	6ba2                	ld	s7,8(sp)
    }
  }
}
 718:	60a6                	ld	ra,72(sp)
 71a:	6406                	ld	s0,64(sp)
 71c:	7942                	ld	s2,48(sp)
 71e:	6161                	addi	sp,sp,80
 720:	8082                	ret

0000000000000722 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 722:	715d                	addi	sp,sp,-80
 724:	ec06                	sd	ra,24(sp)
 726:	e822                	sd	s0,16(sp)
 728:	1000                	addi	s0,sp,32
 72a:	e010                	sd	a2,0(s0)
 72c:	e414                	sd	a3,8(s0)
 72e:	e818                	sd	a4,16(s0)
 730:	ec1c                	sd	a5,24(s0)
 732:	03043023          	sd	a6,32(s0)
 736:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 73a:	8622                	mv	a2,s0
 73c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 740:	00000097          	auipc	ra,0x0
 744:	e16080e7          	jalr	-490(ra) # 556 <vprintf>
}
 748:	60e2                	ld	ra,24(sp)
 74a:	6442                	ld	s0,16(sp)
 74c:	6161                	addi	sp,sp,80
 74e:	8082                	ret

0000000000000750 <printf>:

void
printf(const char *fmt, ...)
{
 750:	711d                	addi	sp,sp,-96
 752:	ec06                	sd	ra,24(sp)
 754:	e822                	sd	s0,16(sp)
 756:	1000                	addi	s0,sp,32
 758:	e40c                	sd	a1,8(s0)
 75a:	e810                	sd	a2,16(s0)
 75c:	ec14                	sd	a3,24(s0)
 75e:	f018                	sd	a4,32(s0)
 760:	f41c                	sd	a5,40(s0)
 762:	03043823          	sd	a6,48(s0)
 766:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76a:	00840613          	addi	a2,s0,8
 76e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 772:	85aa                	mv	a1,a0
 774:	4505                	li	a0,1
 776:	00000097          	auipc	ra,0x0
 77a:	de0080e7          	jalr	-544(ra) # 556 <vprintf>
}
 77e:	60e2                	ld	ra,24(sp)
 780:	6442                	ld	s0,16(sp)
 782:	6125                	addi	sp,sp,96
 784:	8082                	ret

0000000000000786 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 786:	1141                	addi	sp,sp,-16
 788:	e406                	sd	ra,8(sp)
 78a:	e022                	sd	s0,0(sp)
 78c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 792:	00001797          	auipc	a5,0x1
 796:	d8e7b783          	ld	a5,-626(a5) # 1520 <freep>
 79a:	a02d                	j	7c4 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 79c:	4618                	lw	a4,8(a2)
 79e:	9f2d                	addw	a4,a4,a1
 7a0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a4:	6398                	ld	a4,0(a5)
 7a6:	6310                	ld	a2,0(a4)
 7a8:	a83d                	j	7e6 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7aa:	ff852703          	lw	a4,-8(a0)
 7ae:	9f31                	addw	a4,a4,a2
 7b0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7b2:	ff053683          	ld	a3,-16(a0)
 7b6:	a091                	j	7fa <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b8:	6398                	ld	a4,0(a5)
 7ba:	00e7e463          	bltu	a5,a4,7c2 <free+0x3c>
 7be:	00e6ea63          	bltu	a3,a4,7d2 <free+0x4c>
{
 7c2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c4:	fed7fae3          	bgeu	a5,a3,7b8 <free+0x32>
 7c8:	6398                	ld	a4,0(a5)
 7ca:	00e6e463          	bltu	a3,a4,7d2 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ce:	fee7eae3          	bltu	a5,a4,7c2 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7d2:	ff852583          	lw	a1,-8(a0)
 7d6:	6390                	ld	a2,0(a5)
 7d8:	02059813          	slli	a6,a1,0x20
 7dc:	01c85713          	srli	a4,a6,0x1c
 7e0:	9736                	add	a4,a4,a3
 7e2:	fae60de3          	beq	a2,a4,79c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7e6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ea:	4790                	lw	a2,8(a5)
 7ec:	02061593          	slli	a1,a2,0x20
 7f0:	01c5d713          	srli	a4,a1,0x1c
 7f4:	973e                	add	a4,a4,a5
 7f6:	fae68ae3          	beq	a3,a4,7aa <free+0x24>
    p->s.ptr = bp->s.ptr;
 7fa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7fc:	00001717          	auipc	a4,0x1
 800:	d2f73223          	sd	a5,-732(a4) # 1520 <freep>
}
 804:	60a2                	ld	ra,8(sp)
 806:	6402                	ld	s0,0(sp)
 808:	0141                	addi	sp,sp,16
 80a:	8082                	ret

000000000000080c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 80c:	7139                	addi	sp,sp,-64
 80e:	fc06                	sd	ra,56(sp)
 810:	f822                	sd	s0,48(sp)
 812:	f04a                	sd	s2,32(sp)
 814:	ec4e                	sd	s3,24(sp)
 816:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 818:	02051993          	slli	s3,a0,0x20
 81c:	0209d993          	srli	s3,s3,0x20
 820:	09bd                	addi	s3,s3,15
 822:	0049d993          	srli	s3,s3,0x4
 826:	2985                	addiw	s3,s3,1
 828:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 82a:	00001517          	auipc	a0,0x1
 82e:	cf653503          	ld	a0,-778(a0) # 1520 <freep>
 832:	c905                	beqz	a0,862 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 834:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 836:	4798                	lw	a4,8(a5)
 838:	09377a63          	bgeu	a4,s3,8cc <malloc+0xc0>
 83c:	f426                	sd	s1,40(sp)
 83e:	e852                	sd	s4,16(sp)
 840:	e456                	sd	s5,8(sp)
 842:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 844:	8a4e                	mv	s4,s3
 846:	6705                	lui	a4,0x1
 848:	00e9f363          	bgeu	s3,a4,84e <malloc+0x42>
 84c:	6a05                	lui	s4,0x1
 84e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 852:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 856:	00001497          	auipc	s1,0x1
 85a:	cca48493          	addi	s1,s1,-822 # 1520 <freep>
  if(p == (char*)-1)
 85e:	5afd                	li	s5,-1
 860:	a089                	j	8a2 <malloc+0x96>
 862:	f426                	sd	s1,40(sp)
 864:	e852                	sd	s4,16(sp)
 866:	e456                	sd	s5,8(sp)
 868:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 86a:	00001797          	auipc	a5,0x1
 86e:	cd678793          	addi	a5,a5,-810 # 1540 <base>
 872:	00001717          	auipc	a4,0x1
 876:	caf73723          	sd	a5,-850(a4) # 1520 <freep>
 87a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 87c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 880:	b7d1                	j	844 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 882:	6398                	ld	a4,0(a5)
 884:	e118                	sd	a4,0(a0)
 886:	a8b9                	j	8e4 <malloc+0xd8>
  hp->s.size = nu;
 888:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88c:	0541                	addi	a0,a0,16
 88e:	00000097          	auipc	ra,0x0
 892:	ef8080e7          	jalr	-264(ra) # 786 <free>
  return freep;
 896:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 898:	c135                	beqz	a0,8fc <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 89c:	4798                	lw	a4,8(a5)
 89e:	03277363          	bgeu	a4,s2,8c4 <malloc+0xb8>
    if(p == freep)
 8a2:	6098                	ld	a4,0(s1)
 8a4:	853e                	mv	a0,a5
 8a6:	fef71ae3          	bne	a4,a5,89a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8aa:	8552                	mv	a0,s4
 8ac:	00000097          	auipc	ra,0x0
 8b0:	b8e080e7          	jalr	-1138(ra) # 43a <sbrk>
  if(p == (char*)-1)
 8b4:	fd551ae3          	bne	a0,s5,888 <malloc+0x7c>
        return 0;
 8b8:	4501                	li	a0,0
 8ba:	74a2                	ld	s1,40(sp)
 8bc:	6a42                	ld	s4,16(sp)
 8be:	6aa2                	ld	s5,8(sp)
 8c0:	6b02                	ld	s6,0(sp)
 8c2:	a03d                	j	8f0 <malloc+0xe4>
 8c4:	74a2                	ld	s1,40(sp)
 8c6:	6a42                	ld	s4,16(sp)
 8c8:	6aa2                	ld	s5,8(sp)
 8ca:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8cc:	fae90be3          	beq	s2,a4,882 <malloc+0x76>
        p->s.size -= nunits;
 8d0:	4137073b          	subw	a4,a4,s3
 8d4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d6:	02071693          	slli	a3,a4,0x20
 8da:	01c6d713          	srli	a4,a3,0x1c
 8de:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e4:	00001717          	auipc	a4,0x1
 8e8:	c2a73e23          	sd	a0,-964(a4) # 1520 <freep>
      return (void*)(p + 1);
 8ec:	01078513          	addi	a0,a5,16
  }
}
 8f0:	70e2                	ld	ra,56(sp)
 8f2:	7442                	ld	s0,48(sp)
 8f4:	7902                	ld	s2,32(sp)
 8f6:	69e2                	ld	s3,24(sp)
 8f8:	6121                	addi	sp,sp,64
 8fa:	8082                	ret
 8fc:	74a2                	ld	s1,40(sp)
 8fe:	6a42                	ld	s4,16(sp)
 900:	6aa2                	ld	s5,8(sp)
 902:	6b02                	ld	s6,0(sp)
 904:	b7f5                	j	8f0 <malloc+0xe4>

0000000000000906 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 906:	1141                	addi	sp,sp,-16
 908:	e406                	sd	ra,8(sp)
 90a:	e022                	sd	s0,0(sp)
 90c:	0800                	addi	s0,sp,16
  thread_exit(status);
 90e:	2501                	sext.w	a0,a0
 910:	00000097          	auipc	ra,0x0
 914:	b5a080e7          	jalr	-1190(ra) # 46a <thread_exit>
}
 918:	60a2                	ld	ra,8(sp)
 91a:	6402                	ld	s0,0(sp)
 91c:	0141                	addi	sp,sp,16
 91e:	8082                	ret

0000000000000920 <free_stacks>:
int free_stacks() {
 920:	7179                	addi	sp,sp,-48
 922:	f406                	sd	ra,40(sp)
 924:	f022                	sd	s0,32(sp)
 926:	ec26                	sd	s1,24(sp)
 928:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 92a:	00001797          	auipc	a5,0x1
 92e:	c067a783          	lw	a5,-1018(a5) # 1530 <num_threads>
 932:	04f05063          	blez	a5,972 <free_stacks+0x52>
 936:	e84a                	sd	s2,16(sp)
 938:	e44e                	sd	s3,8(sp)
 93a:	4481                	li	s1,0
    free(stacks[i]);
 93c:	00001997          	auipc	s3,0x1
 940:	bec98993          	addi	s3,s3,-1044 # 1528 <stacks>
  for (int i = 0; i < num_threads; i++) {
 944:	00001917          	auipc	s2,0x1
 948:	bec90913          	addi	s2,s2,-1044 # 1530 <num_threads>
    free(stacks[i]);
 94c:	0009b783          	ld	a5,0(s3)
 950:	00349713          	slli	a4,s1,0x3
 954:	97ba                	add	a5,a5,a4
 956:	6388                	ld	a0,0(a5)
 958:	00000097          	auipc	ra,0x0
 95c:	e2e080e7          	jalr	-466(ra) # 786 <free>
  for (int i = 0; i < num_threads; i++) {
 960:	0485                	addi	s1,s1,1
 962:	00092703          	lw	a4,0(s2)
 966:	0004879b          	sext.w	a5,s1
 96a:	fee7c1e3          	blt	a5,a4,94c <free_stacks+0x2c>
 96e:	6942                	ld	s2,16(sp)
 970:	69a2                	ld	s3,8(sp)
  free(stacks);
 972:	00001497          	auipc	s1,0x1
 976:	bb648493          	addi	s1,s1,-1098 # 1528 <stacks>
 97a:	6088                	ld	a0,0(s1)
 97c:	00000097          	auipc	ra,0x0
 980:	e0a080e7          	jalr	-502(ra) # 786 <free>
  stacks = 0;
 984:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 988:	00001797          	auipc	a5,0x1
 98c:	ba07a423          	sw	zero,-1112(a5) # 1530 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 990:	47a1                	li	a5,8
 992:	00001717          	auipc	a4,0x1
 996:	b6f72723          	sw	a5,-1170(a4) # 1500 <max_stacks>
  threads_done = 0;
 99a:	00001797          	auipc	a5,0x1
 99e:	b807ad23          	sw	zero,-1126(a5) # 1534 <threads_done>
}
 9a2:	4501                	li	a0,0
 9a4:	70a2                	ld	ra,40(sp)
 9a6:	7402                	ld	s0,32(sp)
 9a8:	64e2                	ld	s1,24(sp)
 9aa:	6145                	addi	sp,sp,48
 9ac:	8082                	ret

00000000000009ae <expand_num_threads>:
int expand_num_threads() {
 9ae:	1101                	addi	sp,sp,-32
 9b0:	ec06                	sd	ra,24(sp)
 9b2:	e822                	sd	s0,16(sp)
 9b4:	e426                	sd	s1,8(sp)
 9b6:	e04a                	sd	s2,0(sp)
 9b8:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 9ba:	00001797          	auipc	a5,0x1
 9be:	b4678793          	addi	a5,a5,-1210 # 1500 <max_stacks>
 9c2:	4388                	lw	a0,0(a5)
 9c4:	0015151b          	slliw	a0,a0,0x1
 9c8:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 9ca:	0035151b          	slliw	a0,a0,0x3
 9ce:	00000097          	auipc	ra,0x0
 9d2:	e3e080e7          	jalr	-450(ra) # 80c <malloc>
 9d6:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 9d8:	00001617          	auipc	a2,0x1
 9dc:	b5862603          	lw	a2,-1192(a2) # 1530 <num_threads>
 9e0:	00001497          	auipc	s1,0x1
 9e4:	b4848493          	addi	s1,s1,-1208 # 1528 <stacks>
 9e8:	0036161b          	slliw	a2,a2,0x3
 9ec:	608c                	ld	a1,0(s1)
 9ee:	00000097          	auipc	ra,0x0
 9f2:	90a080e7          	jalr	-1782(ra) # 2f8 <memmove>
  free(stacks);
 9f6:	6088                	ld	a0,0(s1)
 9f8:	00000097          	auipc	ra,0x0
 9fc:	d8e080e7          	jalr	-626(ra) # 786 <free>
  stacks = new_stacks;
 a00:	0124b023          	sd	s2,0(s1)
}
 a04:	4501                	li	a0,0
 a06:	60e2                	ld	ra,24(sp)
 a08:	6442                	ld	s0,16(sp)
 a0a:	64a2                	ld	s1,8(sp)
 a0c:	6902                	ld	s2,0(sp)
 a0e:	6105                	addi	sp,sp,32
 a10:	8082                	ret

0000000000000a12 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a12:	7179                	addi	sp,sp,-48
 a14:	f406                	sd	ra,40(sp)
 a16:	f022                	sd	s0,32(sp)
 a18:	e84a                	sd	s2,16(sp)
 a1a:	e44e                	sd	s3,8(sp)
 a1c:	1800                	addi	s0,sp,48
 a1e:	892a                	mv	s2,a0
 a20:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a22:	00001797          	auipc	a5,0x1
 a26:	b067b783          	ld	a5,-1274(a5) # 1528 <stacks>
 a2a:	c3d9                	beqz	a5,ab0 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a2c:	00001797          	auipc	a5,0x1
 a30:	ad47a783          	lw	a5,-1324(a5) # 1500 <max_stacks>
 a34:	00001717          	auipc	a4,0x1
 a38:	afc72703          	lw	a4,-1284(a4) # 1530 <num_threads>
 a3c:	0af71363          	bne	a4,a5,ae2 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 a40:	04000713          	li	a4,64
 a44:	08e78563          	beq	a5,a4,ace <ithread_create+0xbc>
 a48:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a4a:	00000097          	auipc	ra,0x0
 a4e:	f64080e7          	jalr	-156(ra) # 9ae <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a52:	6505                	lui	a0,0x1
 a54:	00000097          	auipc	ra,0x0
 a58:	db8080e7          	jalr	-584(ra) # 80c <malloc>
 a5c:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a5e:	00001717          	auipc	a4,0x1
 a62:	ad272703          	lw	a4,-1326(a4) # 1530 <num_threads>
 a66:	070e                	slli	a4,a4,0x3
 a68:	00001797          	auipc	a5,0x1
 a6c:	ac07b783          	ld	a5,-1344(a5) # 1528 <stacks>
 a70:	97ba                	add	a5,a5,a4
 a72:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a74:	00000697          	auipc	a3,0x0
 a78:	e9268693          	addi	a3,a3,-366 # 906 <ithread_exit>
 a7c:	862a                	mv	a2,a0
 a7e:	85ce                	mv	a1,s3
 a80:	854a                	mv	a0,s2
 a82:	00000097          	auipc	ra,0x0
 a86:	9d8080e7          	jalr	-1576(ra) # 45a <create_thread>
 a8a:	892a                	mv	s2,a0
  if (res != -1) {
 a8c:	57fd                	li	a5,-1
 a8e:	04f50c63          	beq	a0,a5,ae6 <ithread_create+0xd4>
    num_threads++;
 a92:	00001717          	auipc	a4,0x1
 a96:	a9e70713          	addi	a4,a4,-1378 # 1530 <num_threads>
 a9a:	431c                	lw	a5,0(a4)
 a9c:	2785                	addiw	a5,a5,1
 a9e:	c31c                	sw	a5,0(a4)
 aa0:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 aa2:	854a                	mv	a0,s2
 aa4:	70a2                	ld	ra,40(sp)
 aa6:	7402                	ld	s0,32(sp)
 aa8:	6942                	ld	s2,16(sp)
 aaa:	69a2                	ld	s3,8(sp)
 aac:	6145                	addi	sp,sp,48
 aae:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 ab0:	00001517          	auipc	a0,0x1
 ab4:	a5052503          	lw	a0,-1456(a0) # 1500 <max_stacks>
 ab8:	0035151b          	slliw	a0,a0,0x3
 abc:	00000097          	auipc	ra,0x0
 ac0:	d50080e7          	jalr	-688(ra) # 80c <malloc>
 ac4:	00001797          	auipc	a5,0x1
 ac8:	a6a7b223          	sd	a0,-1436(a5) # 1528 <stacks>
 acc:	b785                	j	a2c <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 ace:	00000517          	auipc	a0,0x0
 ad2:	11250513          	addi	a0,a0,274 # be0 <ithread_join+0xd4>
 ad6:	00000097          	auipc	ra,0x0
 ada:	c7a080e7          	jalr	-902(ra) # 750 <printf>
      return -1;
 ade:	597d                	li	s2,-1
 ae0:	b7c9                	j	aa2 <ithread_create+0x90>
 ae2:	ec26                	sd	s1,24(sp)
 ae4:	b7bd                	j	a52 <ithread_create+0x40>
    free(stack_ptr);
 ae6:	8526                	mv	a0,s1
 ae8:	00000097          	auipc	ra,0x0
 aec:	c9e080e7          	jalr	-866(ra) # 786 <free>
    stacks[num_threads] = 0;
 af0:	00001717          	auipc	a4,0x1
 af4:	a4072703          	lw	a4,-1472(a4) # 1530 <num_threads>
 af8:	070e                	slli	a4,a4,0x3
 afa:	00001797          	auipc	a5,0x1
 afe:	a2e7b783          	ld	a5,-1490(a5) # 1528 <stacks>
 b02:	97ba                	add	a5,a5,a4
 b04:	0007b023          	sd	zero,0(a5)
 b08:	64e2                	ld	s1,24(sp)
 b0a:	bf61                	j	aa2 <ithread_create+0x90>

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
 b20:	946080e7          	jalr	-1722(ra) # 462 <join_thread>
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
 b4e:	dd6080e7          	jalr	-554(ra) # 920 <free_stacks>
 b52:	b7f5                	j	b3e <ithread_join+0x32>
