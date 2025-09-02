
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
  12:	b7250513          	addi	a0,a0,-1166 # b80 <ithread_join+0x4e>
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
  3a:	b5290913          	addi	s2,s2,-1198 # b88 <ithread_join+0x56>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	736080e7          	jalr	1846(ra) # 776 <printf>
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
  6e:	b6e50513          	addi	a0,a0,-1170 # bd8 <ithread_join+0xa6>
  72:	00000097          	auipc	ra,0x0
  76:	704080e7          	jalr	1796(ra) # 776 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	336080e7          	jalr	822(ra) # 3b2 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	af850513          	addi	a0,a0,-1288 # b80 <ithread_join+0x4e>
  90:	00000097          	auipc	ra,0x0
  94:	36a080e7          	jalr	874(ra) # 3fa <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	ae650513          	addi	a0,a0,-1306 # b80 <ithread_join+0x4e>
  a2:	00000097          	auipc	ra,0x0
  a6:	350080e7          	jalr	848(ra) # 3f2 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	af450513          	addi	a0,a0,-1292 # ba0 <ithread_join+0x6e>
  b4:	00000097          	auipc	ra,0x0
  b8:	6c2080e7          	jalr	1730(ra) # 776 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2f4080e7          	jalr	756(ra) # 3b2 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	44a58593          	addi	a1,a1,1098 # 1510 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	aea50513          	addi	a0,a0,-1302 # bb8 <ithread_join+0x86>
  d6:	00000097          	auipc	ra,0x0
  da:	314080e7          	jalr	788(ra) # 3ea <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	ae250513          	addi	a0,a0,-1310 # bc0 <ithread_join+0x8e>
  e6:	00000097          	auipc	ra,0x0
  ea:	690080e7          	jalr	1680(ra) # 776 <printf>
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

000000000000049a <send>:
.global send
send:
 li a7, SYS_send
 49a:	48fd                	li	a7,31
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <recv>:
.global recv
recv:
 li a7, SYS_recv
 4a2:	02000893          	li	a7,32
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 4ac:	02100893          	li	a7,33
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 4b6:	02200893          	li	a7,34
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4c0:	1101                	addi	sp,sp,-32
 4c2:	ec06                	sd	ra,24(sp)
 4c4:	e822                	sd	s0,16(sp)
 4c6:	1000                	addi	s0,sp,32
 4c8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4cc:	4605                	li	a2,1
 4ce:	fef40593          	addi	a1,s0,-17
 4d2:	00000097          	auipc	ra,0x0
 4d6:	f00080e7          	jalr	-256(ra) # 3d2 <write>
}
 4da:	60e2                	ld	ra,24(sp)
 4dc:	6442                	ld	s0,16(sp)
 4de:	6105                	addi	sp,sp,32
 4e0:	8082                	ret

00000000000004e2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e2:	7139                	addi	sp,sp,-64
 4e4:	fc06                	sd	ra,56(sp)
 4e6:	f822                	sd	s0,48(sp)
 4e8:	f426                	sd	s1,40(sp)
 4ea:	f04a                	sd	s2,32(sp)
 4ec:	ec4e                	sd	s3,24(sp)
 4ee:	0080                	addi	s0,sp,64
 4f0:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4f2:	c299                	beqz	a3,4f8 <printint+0x16>
 4f4:	0805c063          	bltz	a1,574 <printint+0x92>
  neg = 0;
 4f8:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4fa:	fc040313          	addi	t1,s0,-64
  neg = 0;
 4fe:	869a                	mv	a3,t1
  i = 0;
 500:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 502:	00000817          	auipc	a6,0x0
 506:	78680813          	addi	a6,a6,1926 # c88 <digits>
 50a:	88be                	mv	a7,a5
 50c:	0017851b          	addiw	a0,a5,1
 510:	87aa                	mv	a5,a0
 512:	02c5f73b          	remuw	a4,a1,a2
 516:	1702                	slli	a4,a4,0x20
 518:	9301                	srli	a4,a4,0x20
 51a:	9742                	add	a4,a4,a6
 51c:	00074703          	lbu	a4,0(a4)
 520:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 524:	872e                	mv	a4,a1
 526:	02c5d5bb          	divuw	a1,a1,a2
 52a:	0685                	addi	a3,a3,1
 52c:	fcc77fe3          	bgeu	a4,a2,50a <printint+0x28>
  if(neg)
 530:	000e0c63          	beqz	t3,548 <printint+0x66>
    buf[i++] = '-';
 534:	fd050793          	addi	a5,a0,-48
 538:	00878533          	add	a0,a5,s0
 53c:	02d00793          	li	a5,45
 540:	fef50823          	sb	a5,-16(a0)
 544:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 548:	fff7899b          	addiw	s3,a5,-1
 54c:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 550:	fff4c583          	lbu	a1,-1(s1)
 554:	854a                	mv	a0,s2
 556:	00000097          	auipc	ra,0x0
 55a:	f6a080e7          	jalr	-150(ra) # 4c0 <putc>
  while(--i >= 0)
 55e:	39fd                	addiw	s3,s3,-1
 560:	14fd                	addi	s1,s1,-1
 562:	fe09d7e3          	bgez	s3,550 <printint+0x6e>
}
 566:	70e2                	ld	ra,56(sp)
 568:	7442                	ld	s0,48(sp)
 56a:	74a2                	ld	s1,40(sp)
 56c:	7902                	ld	s2,32(sp)
 56e:	69e2                	ld	s3,24(sp)
 570:	6121                	addi	sp,sp,64
 572:	8082                	ret
    x = -xx;
 574:	40b005bb          	negw	a1,a1
    neg = 1;
 578:	4e05                	li	t3,1
    x = -xx;
 57a:	b741                	j	4fa <printint+0x18>

000000000000057c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 57c:	715d                	addi	sp,sp,-80
 57e:	e486                	sd	ra,72(sp)
 580:	e0a2                	sd	s0,64(sp)
 582:	f84a                	sd	s2,48(sp)
 584:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 586:	0005c903          	lbu	s2,0(a1)
 58a:	1a090a63          	beqz	s2,73e <vprintf+0x1c2>
 58e:	fc26                	sd	s1,56(sp)
 590:	f44e                	sd	s3,40(sp)
 592:	f052                	sd	s4,32(sp)
 594:	ec56                	sd	s5,24(sp)
 596:	e85a                	sd	s6,16(sp)
 598:	e45e                	sd	s7,8(sp)
 59a:	8aaa                	mv	s5,a0
 59c:	8bb2                	mv	s7,a2
 59e:	00158493          	addi	s1,a1,1
  state = 0;
 5a2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5a4:	02500a13          	li	s4,37
 5a8:	4b55                	li	s6,21
 5aa:	a839                	j	5c8 <vprintf+0x4c>
        putc(fd, c);
 5ac:	85ca                	mv	a1,s2
 5ae:	8556                	mv	a0,s5
 5b0:	00000097          	auipc	ra,0x0
 5b4:	f10080e7          	jalr	-240(ra) # 4c0 <putc>
 5b8:	a019                	j	5be <vprintf+0x42>
    } else if(state == '%'){
 5ba:	01498d63          	beq	s3,s4,5d4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5be:	0485                	addi	s1,s1,1
 5c0:	fff4c903          	lbu	s2,-1(s1)
 5c4:	16090763          	beqz	s2,732 <vprintf+0x1b6>
    if(state == 0){
 5c8:	fe0999e3          	bnez	s3,5ba <vprintf+0x3e>
      if(c == '%'){
 5cc:	ff4910e3          	bne	s2,s4,5ac <vprintf+0x30>
        state = '%';
 5d0:	89d2                	mv	s3,s4
 5d2:	b7f5                	j	5be <vprintf+0x42>
      if(c == 'd'){
 5d4:	13490463          	beq	s2,s4,6fc <vprintf+0x180>
 5d8:	f9d9079b          	addiw	a5,s2,-99
 5dc:	0ff7f793          	zext.b	a5,a5
 5e0:	12fb6763          	bltu	s6,a5,70e <vprintf+0x192>
 5e4:	f9d9079b          	addiw	a5,s2,-99
 5e8:	0ff7f713          	zext.b	a4,a5
 5ec:	12eb6163          	bltu	s6,a4,70e <vprintf+0x192>
 5f0:	00271793          	slli	a5,a4,0x2
 5f4:	00000717          	auipc	a4,0x0
 5f8:	63c70713          	addi	a4,a4,1596 # c30 <ithread_join+0xfe>
 5fc:	97ba                	add	a5,a5,a4
 5fe:	439c                	lw	a5,0(a5)
 600:	97ba                	add	a5,a5,a4
 602:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 604:	008b8913          	addi	s2,s7,8
 608:	4685                	li	a3,1
 60a:	4629                	li	a2,10
 60c:	000ba583          	lw	a1,0(s7)
 610:	8556                	mv	a0,s5
 612:	00000097          	auipc	ra,0x0
 616:	ed0080e7          	jalr	-304(ra) # 4e2 <printint>
 61a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 61c:	4981                	li	s3,0
 61e:	b745                	j	5be <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 620:	008b8913          	addi	s2,s7,8
 624:	4681                	li	a3,0
 626:	4629                	li	a2,10
 628:	000ba583          	lw	a1,0(s7)
 62c:	8556                	mv	a0,s5
 62e:	00000097          	auipc	ra,0x0
 632:	eb4080e7          	jalr	-332(ra) # 4e2 <printint>
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	b751                	j	5be <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 63c:	008b8913          	addi	s2,s7,8
 640:	4681                	li	a3,0
 642:	4641                	li	a2,16
 644:	000ba583          	lw	a1,0(s7)
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	e98080e7          	jalr	-360(ra) # 4e2 <printint>
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
 656:	b7a5                	j	5be <vprintf+0x42>
 658:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 65a:	008b8c13          	addi	s8,s7,8
 65e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 662:	03000593          	li	a1,48
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e58080e7          	jalr	-424(ra) # 4c0 <putc>
  putc(fd, 'x');
 670:	07800593          	li	a1,120
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	e4a080e7          	jalr	-438(ra) # 4c0 <putc>
 67e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 680:	00000b97          	auipc	s7,0x0
 684:	608b8b93          	addi	s7,s7,1544 # c88 <digits>
 688:	03c9d793          	srli	a5,s3,0x3c
 68c:	97de                	add	a5,a5,s7
 68e:	0007c583          	lbu	a1,0(a5)
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	e2c080e7          	jalr	-468(ra) # 4c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69c:	0992                	slli	s3,s3,0x4
 69e:	397d                	addiw	s2,s2,-1
 6a0:	fe0914e3          	bnez	s2,688 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6a4:	8be2                	mv	s7,s8
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	6c02                	ld	s8,0(sp)
 6aa:	bf11                	j	5be <vprintf+0x42>
        s = va_arg(ap, char*);
 6ac:	008b8993          	addi	s3,s7,8
 6b0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6b4:	02090163          	beqz	s2,6d6 <vprintf+0x15a>
        while(*s != 0){
 6b8:	00094583          	lbu	a1,0(s2)
 6bc:	c9a5                	beqz	a1,72c <vprintf+0x1b0>
          putc(fd, *s);
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	e00080e7          	jalr	-512(ra) # 4c0 <putc>
          s++;
 6c8:	0905                	addi	s2,s2,1
        while(*s != 0){
 6ca:	00094583          	lbu	a1,0(s2)
 6ce:	f9e5                	bnez	a1,6be <vprintf+0x142>
        s = va_arg(ap, char*);
 6d0:	8bce                	mv	s7,s3
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b5ed                	j	5be <vprintf+0x42>
          s = "(null)";
 6d6:	00000917          	auipc	s2,0x0
 6da:	52290913          	addi	s2,s2,1314 # bf8 <ithread_join+0xc6>
        while(*s != 0){
 6de:	02800593          	li	a1,40
 6e2:	bff1                	j	6be <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6e4:	008b8913          	addi	s2,s7,8
 6e8:	000bc583          	lbu	a1,0(s7)
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	dd2080e7          	jalr	-558(ra) # 4c0 <putc>
 6f6:	8bca                	mv	s7,s2
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	b5d1                	j	5be <vprintf+0x42>
        putc(fd, c);
 6fc:	02500593          	li	a1,37
 700:	8556                	mv	a0,s5
 702:	00000097          	auipc	ra,0x0
 706:	dbe080e7          	jalr	-578(ra) # 4c0 <putc>
      state = 0;
 70a:	4981                	li	s3,0
 70c:	bd4d                	j	5be <vprintf+0x42>
        putc(fd, '%');
 70e:	02500593          	li	a1,37
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	dac080e7          	jalr	-596(ra) # 4c0 <putc>
        putc(fd, c);
 71c:	85ca                	mv	a1,s2
 71e:	8556                	mv	a0,s5
 720:	00000097          	auipc	ra,0x0
 724:	da0080e7          	jalr	-608(ra) # 4c0 <putc>
      state = 0;
 728:	4981                	li	s3,0
 72a:	bd51                	j	5be <vprintf+0x42>
        s = va_arg(ap, char*);
 72c:	8bce                	mv	s7,s3
      state = 0;
 72e:	4981                	li	s3,0
 730:	b579                	j	5be <vprintf+0x42>
 732:	74e2                	ld	s1,56(sp)
 734:	79a2                	ld	s3,40(sp)
 736:	7a02                	ld	s4,32(sp)
 738:	6ae2                	ld	s5,24(sp)
 73a:	6b42                	ld	s6,16(sp)
 73c:	6ba2                	ld	s7,8(sp)
    }
  }
}
 73e:	60a6                	ld	ra,72(sp)
 740:	6406                	ld	s0,64(sp)
 742:	7942                	ld	s2,48(sp)
 744:	6161                	addi	sp,sp,80
 746:	8082                	ret

0000000000000748 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 748:	715d                	addi	sp,sp,-80
 74a:	ec06                	sd	ra,24(sp)
 74c:	e822                	sd	s0,16(sp)
 74e:	1000                	addi	s0,sp,32
 750:	e010                	sd	a2,0(s0)
 752:	e414                	sd	a3,8(s0)
 754:	e818                	sd	a4,16(s0)
 756:	ec1c                	sd	a5,24(s0)
 758:	03043023          	sd	a6,32(s0)
 75c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 760:	8622                	mv	a2,s0
 762:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 766:	00000097          	auipc	ra,0x0
 76a:	e16080e7          	jalr	-490(ra) # 57c <vprintf>
}
 76e:	60e2                	ld	ra,24(sp)
 770:	6442                	ld	s0,16(sp)
 772:	6161                	addi	sp,sp,80
 774:	8082                	ret

0000000000000776 <printf>:

void
printf(const char *fmt, ...)
{
 776:	711d                	addi	sp,sp,-96
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	e40c                	sd	a1,8(s0)
 780:	e810                	sd	a2,16(s0)
 782:	ec14                	sd	a3,24(s0)
 784:	f018                	sd	a4,32(s0)
 786:	f41c                	sd	a5,40(s0)
 788:	03043823          	sd	a6,48(s0)
 78c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 790:	00840613          	addi	a2,s0,8
 794:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 798:	85aa                	mv	a1,a0
 79a:	4505                	li	a0,1
 79c:	00000097          	auipc	ra,0x0
 7a0:	de0080e7          	jalr	-544(ra) # 57c <vprintf>
}
 7a4:	60e2                	ld	ra,24(sp)
 7a6:	6442                	ld	s0,16(sp)
 7a8:	6125                	addi	sp,sp,96
 7aa:	8082                	ret

00000000000007ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ac:	1141                	addi	sp,sp,-16
 7ae:	e406                	sd	ra,8(sp)
 7b0:	e022                	sd	s0,0(sp)
 7b2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	00001797          	auipc	a5,0x1
 7bc:	d687b783          	ld	a5,-664(a5) # 1520 <freep>
 7c0:	a02d                	j	7ea <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c2:	4618                	lw	a4,8(a2)
 7c4:	9f2d                	addw	a4,a4,a1
 7c6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ca:	6398                	ld	a4,0(a5)
 7cc:	6310                	ld	a2,0(a4)
 7ce:	a83d                	j	80c <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d0:	ff852703          	lw	a4,-8(a0)
 7d4:	9f31                	addw	a4,a4,a2
 7d6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d8:	ff053683          	ld	a3,-16(a0)
 7dc:	a091                	j	820 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7de:	6398                	ld	a4,0(a5)
 7e0:	00e7e463          	bltu	a5,a4,7e8 <free+0x3c>
 7e4:	00e6ea63          	bltu	a3,a4,7f8 <free+0x4c>
{
 7e8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ea:	fed7fae3          	bgeu	a5,a3,7de <free+0x32>
 7ee:	6398                	ld	a4,0(a5)
 7f0:	00e6e463          	bltu	a3,a4,7f8 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f4:	fee7eae3          	bltu	a5,a4,7e8 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7f8:	ff852583          	lw	a1,-8(a0)
 7fc:	6390                	ld	a2,0(a5)
 7fe:	02059813          	slli	a6,a1,0x20
 802:	01c85713          	srli	a4,a6,0x1c
 806:	9736                	add	a4,a4,a3
 808:	fae60de3          	beq	a2,a4,7c2 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 80c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 810:	4790                	lw	a2,8(a5)
 812:	02061593          	slli	a1,a2,0x20
 816:	01c5d713          	srli	a4,a1,0x1c
 81a:	973e                	add	a4,a4,a5
 81c:	fae68ae3          	beq	a3,a4,7d0 <free+0x24>
    p->s.ptr = bp->s.ptr;
 820:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 822:	00001717          	auipc	a4,0x1
 826:	cef73f23          	sd	a5,-770(a4) # 1520 <freep>
}
 82a:	60a2                	ld	ra,8(sp)
 82c:	6402                	ld	s0,0(sp)
 82e:	0141                	addi	sp,sp,16
 830:	8082                	ret

0000000000000832 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 832:	7139                	addi	sp,sp,-64
 834:	fc06                	sd	ra,56(sp)
 836:	f822                	sd	s0,48(sp)
 838:	f04a                	sd	s2,32(sp)
 83a:	ec4e                	sd	s3,24(sp)
 83c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83e:	02051993          	slli	s3,a0,0x20
 842:	0209d993          	srli	s3,s3,0x20
 846:	09bd                	addi	s3,s3,15
 848:	0049d993          	srli	s3,s3,0x4
 84c:	2985                	addiw	s3,s3,1
 84e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 850:	00001517          	auipc	a0,0x1
 854:	cd053503          	ld	a0,-816(a0) # 1520 <freep>
 858:	c905                	beqz	a0,888 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85c:	4798                	lw	a4,8(a5)
 85e:	09377a63          	bgeu	a4,s3,8f2 <malloc+0xc0>
 862:	f426                	sd	s1,40(sp)
 864:	e852                	sd	s4,16(sp)
 866:	e456                	sd	s5,8(sp)
 868:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 86a:	8a4e                	mv	s4,s3
 86c:	6705                	lui	a4,0x1
 86e:	00e9f363          	bgeu	s3,a4,874 <malloc+0x42>
 872:	6a05                	lui	s4,0x1
 874:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 878:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 87c:	00001497          	auipc	s1,0x1
 880:	ca448493          	addi	s1,s1,-860 # 1520 <freep>
  if(p == (char*)-1)
 884:	5afd                	li	s5,-1
 886:	a089                	j	8c8 <malloc+0x96>
 888:	f426                	sd	s1,40(sp)
 88a:	e852                	sd	s4,16(sp)
 88c:	e456                	sd	s5,8(sp)
 88e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 890:	00001797          	auipc	a5,0x1
 894:	cb078793          	addi	a5,a5,-848 # 1540 <base>
 898:	00001717          	auipc	a4,0x1
 89c:	c8f73423          	sd	a5,-888(a4) # 1520 <freep>
 8a0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a6:	b7d1                	j	86a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8a8:	6398                	ld	a4,0(a5)
 8aa:	e118                	sd	a4,0(a0)
 8ac:	a8b9                	j	90a <malloc+0xd8>
  hp->s.size = nu;
 8ae:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b2:	0541                	addi	a0,a0,16
 8b4:	00000097          	auipc	ra,0x0
 8b8:	ef8080e7          	jalr	-264(ra) # 7ac <free>
  return freep;
 8bc:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8be:	c135                	beqz	a0,922 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c2:	4798                	lw	a4,8(a5)
 8c4:	03277363          	bgeu	a4,s2,8ea <malloc+0xb8>
    if(p == freep)
 8c8:	6098                	ld	a4,0(s1)
 8ca:	853e                	mv	a0,a5
 8cc:	fef71ae3          	bne	a4,a5,8c0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8d0:	8552                	mv	a0,s4
 8d2:	00000097          	auipc	ra,0x0
 8d6:	b68080e7          	jalr	-1176(ra) # 43a <sbrk>
  if(p == (char*)-1)
 8da:	fd551ae3          	bne	a0,s5,8ae <malloc+0x7c>
        return 0;
 8de:	4501                	li	a0,0
 8e0:	74a2                	ld	s1,40(sp)
 8e2:	6a42                	ld	s4,16(sp)
 8e4:	6aa2                	ld	s5,8(sp)
 8e6:	6b02                	ld	s6,0(sp)
 8e8:	a03d                	j	916 <malloc+0xe4>
 8ea:	74a2                	ld	s1,40(sp)
 8ec:	6a42                	ld	s4,16(sp)
 8ee:	6aa2                	ld	s5,8(sp)
 8f0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8f2:	fae90be3          	beq	s2,a4,8a8 <malloc+0x76>
        p->s.size -= nunits;
 8f6:	4137073b          	subw	a4,a4,s3
 8fa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8fc:	02071693          	slli	a3,a4,0x20
 900:	01c6d713          	srli	a4,a3,0x1c
 904:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 906:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 90a:	00001717          	auipc	a4,0x1
 90e:	c0a73b23          	sd	a0,-1002(a4) # 1520 <freep>
      return (void*)(p + 1);
 912:	01078513          	addi	a0,a5,16
  }
}
 916:	70e2                	ld	ra,56(sp)
 918:	7442                	ld	s0,48(sp)
 91a:	7902                	ld	s2,32(sp)
 91c:	69e2                	ld	s3,24(sp)
 91e:	6121                	addi	sp,sp,64
 920:	8082                	ret
 922:	74a2                	ld	s1,40(sp)
 924:	6a42                	ld	s4,16(sp)
 926:	6aa2                	ld	s5,8(sp)
 928:	6b02                	ld	s6,0(sp)
 92a:	b7f5                	j	916 <malloc+0xe4>

000000000000092c <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 92c:	1141                	addi	sp,sp,-16
 92e:	e406                	sd	ra,8(sp)
 930:	e022                	sd	s0,0(sp)
 932:	0800                	addi	s0,sp,16
  thread_exit(status);
 934:	2501                	sext.w	a0,a0
 936:	00000097          	auipc	ra,0x0
 93a:	b34080e7          	jalr	-1228(ra) # 46a <thread_exit>
}
 93e:	60a2                	ld	ra,8(sp)
 940:	6402                	ld	s0,0(sp)
 942:	0141                	addi	sp,sp,16
 944:	8082                	ret

0000000000000946 <free_stacks>:
int free_stacks() {
 946:	7179                	addi	sp,sp,-48
 948:	f406                	sd	ra,40(sp)
 94a:	f022                	sd	s0,32(sp)
 94c:	ec26                	sd	s1,24(sp)
 94e:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 950:	00001797          	auipc	a5,0x1
 954:	be07a783          	lw	a5,-1056(a5) # 1530 <num_threads>
 958:	04f05063          	blez	a5,998 <free_stacks+0x52>
 95c:	e84a                	sd	s2,16(sp)
 95e:	e44e                	sd	s3,8(sp)
 960:	4481                	li	s1,0
    free(stacks[i]);
 962:	00001997          	auipc	s3,0x1
 966:	bc698993          	addi	s3,s3,-1082 # 1528 <stacks>
  for (int i = 0; i < num_threads; i++) {
 96a:	00001917          	auipc	s2,0x1
 96e:	bc690913          	addi	s2,s2,-1082 # 1530 <num_threads>
    free(stacks[i]);
 972:	0009b783          	ld	a5,0(s3)
 976:	00349713          	slli	a4,s1,0x3
 97a:	97ba                	add	a5,a5,a4
 97c:	6388                	ld	a0,0(a5)
 97e:	00000097          	auipc	ra,0x0
 982:	e2e080e7          	jalr	-466(ra) # 7ac <free>
  for (int i = 0; i < num_threads; i++) {
 986:	0485                	addi	s1,s1,1
 988:	00092703          	lw	a4,0(s2)
 98c:	0004879b          	sext.w	a5,s1
 990:	fee7c1e3          	blt	a5,a4,972 <free_stacks+0x2c>
 994:	6942                	ld	s2,16(sp)
 996:	69a2                	ld	s3,8(sp)
  free(stacks);
 998:	00001497          	auipc	s1,0x1
 99c:	b9048493          	addi	s1,s1,-1136 # 1528 <stacks>
 9a0:	6088                	ld	a0,0(s1)
 9a2:	00000097          	auipc	ra,0x0
 9a6:	e0a080e7          	jalr	-502(ra) # 7ac <free>
  stacks = 0;
 9aa:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 9ae:	00001797          	auipc	a5,0x1
 9b2:	b807a123          	sw	zero,-1150(a5) # 1530 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 9b6:	47a1                	li	a5,8
 9b8:	00001717          	auipc	a4,0x1
 9bc:	b4f72423          	sw	a5,-1208(a4) # 1500 <max_stacks>
  threads_done = 0;
 9c0:	00001797          	auipc	a5,0x1
 9c4:	b607aa23          	sw	zero,-1164(a5) # 1534 <threads_done>
}
 9c8:	4501                	li	a0,0
 9ca:	70a2                	ld	ra,40(sp)
 9cc:	7402                	ld	s0,32(sp)
 9ce:	64e2                	ld	s1,24(sp)
 9d0:	6145                	addi	sp,sp,48
 9d2:	8082                	ret

00000000000009d4 <expand_num_threads>:
int expand_num_threads() {
 9d4:	1101                	addi	sp,sp,-32
 9d6:	ec06                	sd	ra,24(sp)
 9d8:	e822                	sd	s0,16(sp)
 9da:	e426                	sd	s1,8(sp)
 9dc:	e04a                	sd	s2,0(sp)
 9de:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 9e0:	00001797          	auipc	a5,0x1
 9e4:	b2078793          	addi	a5,a5,-1248 # 1500 <max_stacks>
 9e8:	4388                	lw	a0,0(a5)
 9ea:	0015151b          	slliw	a0,a0,0x1
 9ee:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 9f0:	0035151b          	slliw	a0,a0,0x3
 9f4:	00000097          	auipc	ra,0x0
 9f8:	e3e080e7          	jalr	-450(ra) # 832 <malloc>
 9fc:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 9fe:	00001617          	auipc	a2,0x1
 a02:	b3262603          	lw	a2,-1230(a2) # 1530 <num_threads>
 a06:	00001497          	auipc	s1,0x1
 a0a:	b2248493          	addi	s1,s1,-1246 # 1528 <stacks>
 a0e:	0036161b          	slliw	a2,a2,0x3
 a12:	608c                	ld	a1,0(s1)
 a14:	00000097          	auipc	ra,0x0
 a18:	8e4080e7          	jalr	-1820(ra) # 2f8 <memmove>
  free(stacks);
 a1c:	6088                	ld	a0,0(s1)
 a1e:	00000097          	auipc	ra,0x0
 a22:	d8e080e7          	jalr	-626(ra) # 7ac <free>
  stacks = new_stacks;
 a26:	0124b023          	sd	s2,0(s1)
}
 a2a:	4501                	li	a0,0
 a2c:	60e2                	ld	ra,24(sp)
 a2e:	6442                	ld	s0,16(sp)
 a30:	64a2                	ld	s1,8(sp)
 a32:	6902                	ld	s2,0(sp)
 a34:	6105                	addi	sp,sp,32
 a36:	8082                	ret

0000000000000a38 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a38:	7179                	addi	sp,sp,-48
 a3a:	f406                	sd	ra,40(sp)
 a3c:	f022                	sd	s0,32(sp)
 a3e:	e84a                	sd	s2,16(sp)
 a40:	e44e                	sd	s3,8(sp)
 a42:	1800                	addi	s0,sp,48
 a44:	892a                	mv	s2,a0
 a46:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a48:	00001797          	auipc	a5,0x1
 a4c:	ae07b783          	ld	a5,-1312(a5) # 1528 <stacks>
 a50:	c3d9                	beqz	a5,ad6 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a52:	00001797          	auipc	a5,0x1
 a56:	aae7a783          	lw	a5,-1362(a5) # 1500 <max_stacks>
 a5a:	00001717          	auipc	a4,0x1
 a5e:	ad672703          	lw	a4,-1322(a4) # 1530 <num_threads>
 a62:	0af71363          	bne	a4,a5,b08 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 a66:	04000713          	li	a4,64
 a6a:	08e78563          	beq	a5,a4,af4 <ithread_create+0xbc>
 a6e:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a70:	00000097          	auipc	ra,0x0
 a74:	f64080e7          	jalr	-156(ra) # 9d4 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a78:	6505                	lui	a0,0x1
 a7a:	00000097          	auipc	ra,0x0
 a7e:	db8080e7          	jalr	-584(ra) # 832 <malloc>
 a82:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a84:	00001717          	auipc	a4,0x1
 a88:	aac72703          	lw	a4,-1364(a4) # 1530 <num_threads>
 a8c:	070e                	slli	a4,a4,0x3
 a8e:	00001797          	auipc	a5,0x1
 a92:	a9a7b783          	ld	a5,-1382(a5) # 1528 <stacks>
 a96:	97ba                	add	a5,a5,a4
 a98:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a9a:	00000697          	auipc	a3,0x0
 a9e:	e9268693          	addi	a3,a3,-366 # 92c <ithread_exit>
 aa2:	862a                	mv	a2,a0
 aa4:	85ce                	mv	a1,s3
 aa6:	854a                	mv	a0,s2
 aa8:	00000097          	auipc	ra,0x0
 aac:	9b2080e7          	jalr	-1614(ra) # 45a <create_thread>
 ab0:	892a                	mv	s2,a0
  if (res != -1) {
 ab2:	57fd                	li	a5,-1
 ab4:	04f50c63          	beq	a0,a5,b0c <ithread_create+0xd4>
    num_threads++;
 ab8:	00001717          	auipc	a4,0x1
 abc:	a7870713          	addi	a4,a4,-1416 # 1530 <num_threads>
 ac0:	431c                	lw	a5,0(a4)
 ac2:	2785                	addiw	a5,a5,1
 ac4:	c31c                	sw	a5,0(a4)
 ac6:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 ac8:	854a                	mv	a0,s2
 aca:	70a2                	ld	ra,40(sp)
 acc:	7402                	ld	s0,32(sp)
 ace:	6942                	ld	s2,16(sp)
 ad0:	69a2                	ld	s3,8(sp)
 ad2:	6145                	addi	sp,sp,48
 ad4:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 ad6:	00001517          	auipc	a0,0x1
 ada:	a2a52503          	lw	a0,-1494(a0) # 1500 <max_stacks>
 ade:	0035151b          	slliw	a0,a0,0x3
 ae2:	00000097          	auipc	ra,0x0
 ae6:	d50080e7          	jalr	-688(ra) # 832 <malloc>
 aea:	00001797          	auipc	a5,0x1
 aee:	a2a7bf23          	sd	a0,-1474(a5) # 1528 <stacks>
 af2:	b785                	j	a52 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 af4:	00000517          	auipc	a0,0x0
 af8:	10c50513          	addi	a0,a0,268 # c00 <ithread_join+0xce>
 afc:	00000097          	auipc	ra,0x0
 b00:	c7a080e7          	jalr	-902(ra) # 776 <printf>
      return -1;
 b04:	597d                	li	s2,-1
 b06:	b7c9                	j	ac8 <ithread_create+0x90>
 b08:	ec26                	sd	s1,24(sp)
 b0a:	b7bd                	j	a78 <ithread_create+0x40>
    free(stack_ptr);
 b0c:	8526                	mv	a0,s1
 b0e:	00000097          	auipc	ra,0x0
 b12:	c9e080e7          	jalr	-866(ra) # 7ac <free>
    stacks[num_threads] = 0;
 b16:	00001717          	auipc	a4,0x1
 b1a:	a1a72703          	lw	a4,-1510(a4) # 1530 <num_threads>
 b1e:	070e                	slli	a4,a4,0x3
 b20:	00001797          	auipc	a5,0x1
 b24:	a087b783          	ld	a5,-1528(a5) # 1528 <stacks>
 b28:	97ba                	add	a5,a5,a4
 b2a:	0007b023          	sd	zero,0(a5)
 b2e:	64e2                	ld	s1,24(sp)
 b30:	bf61                	j	ac8 <ithread_create+0x90>

0000000000000b32 <ithread_join>:

int ithread_join(int thread_id) {
 b32:	1101                	addi	sp,sp,-32
 b34:	ec06                	sd	ra,24(sp)
 b36:	e822                	sd	s0,16(sp)
 b38:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b3a:	ff040793          	addi	a5,s0,-16
 b3e:	ffc7859b          	addiw	a1,a5,-4
 b42:	00000097          	auipc	ra,0x0
 b46:	920080e7          	jalr	-1760(ra) # 462 <join_thread>
  threads_done++;
 b4a:	00001717          	auipc	a4,0x1
 b4e:	9ea70713          	addi	a4,a4,-1558 # 1534 <threads_done>
 b52:	431c                	lw	a5,0(a4)
 b54:	2785                	addiw	a5,a5,1
 b56:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b58:	00001717          	auipc	a4,0x1
 b5c:	9d872703          	lw	a4,-1576(a4) # 1530 <num_threads>
 b60:	00f70863          	beq	a4,a5,b70 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 b64:	fec42503          	lw	a0,-20(s0)
 b68:	60e2                	ld	ra,24(sp)
 b6a:	6442                	ld	s0,16(sp)
 b6c:	6105                	addi	sp,sp,32
 b6e:	8082                	ret
    free_stacks();
 b70:	00000097          	auipc	ra,0x0
 b74:	dd6080e7          	jalr	-554(ra) # 946 <free_stacks>
 b78:	b7f5                	j	b64 <ithread_join+0x32>
