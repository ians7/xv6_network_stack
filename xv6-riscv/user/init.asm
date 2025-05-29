
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
  12:	af250513          	addi	a0,a0,-1294 # b00 <ithread_join+0x4c>
  16:	00000097          	auipc	ra,0x0
  1a:	3a8080e7          	jalr	936(ra) # 3be <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3d2080e7          	jalr	978(ra) # 3f6 <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3c8080e7          	jalr	968(ra) # 3f6 <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	ad290913          	addi	s2,s2,-1326 # b08 <ithread_join+0x54>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6d8080e7          	jalr	1752(ra) # 718 <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	32e080e7          	jalr	814(ra) # 376 <fork>
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
  5e:	32c080e7          	jalr	812(ra) # 386 <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	aee50513          	addi	a0,a0,-1298 # b58 <ithread_join+0xa4>
  72:	00000097          	auipc	ra,0x0
  76:	6a6080e7          	jalr	1702(ra) # 718 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	302080e7          	jalr	770(ra) # 37e <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	a7850513          	addi	a0,a0,-1416 # b00 <ithread_join+0x4c>
  90:	00000097          	auipc	ra,0x0
  94:	336080e7          	jalr	822(ra) # 3c6 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	a6650513          	addi	a0,a0,-1434 # b00 <ithread_join+0x4c>
  a2:	00000097          	auipc	ra,0x0
  a6:	31c080e7          	jalr	796(ra) # 3be <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	a7450513          	addi	a0,a0,-1420 # b20 <ithread_join+0x6c>
  b4:	00000097          	auipc	ra,0x0
  b8:	664080e7          	jalr	1636(ra) # 718 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2c0080e7          	jalr	704(ra) # 37e <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	f4a58593          	addi	a1,a1,-182 # 1010 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	a6a50513          	addi	a0,a0,-1430 # b38 <ithread_join+0x84>
  d6:	00000097          	auipc	ra,0x0
  da:	2e0080e7          	jalr	736(ra) # 3b6 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	a6250513          	addi	a0,a0,-1438 # b40 <ithread_join+0x8c>
  e6:	00000097          	auipc	ra,0x0
  ea:	632080e7          	jalr	1586(ra) # 718 <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	28e080e7          	jalr	654(ra) # 37e <exit>

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
 10e:	274080e7          	jalr	628(ra) # 37e <exit>

0000000000000112 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 112:	1141                	addi	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 118:	87aa                	mv	a5,a0
 11a:	0585                	addi	a1,a1,1
 11c:	0785                	addi	a5,a5,1
 11e:	fff5c703          	lbu	a4,-1(a1)
 122:	fee78fa3          	sb	a4,-1(a5)
 126:	fb75                	bnez	a4,11a <strcpy+0x8>
    ;
  return os;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	cb91                	beqz	a5,14c <strcmp+0x1e>
 13a:	0005c703          	lbu	a4,0(a1)
 13e:	00f71763          	bne	a4,a5,14c <strcmp+0x1e>
    p++, q++;
 142:	0505                	addi	a0,a0,1
 144:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbe5                	bnez	a5,13a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14c:	0005c503          	lbu	a0,0(a1)
}
 150:	40a7853b          	subw	a0,a5,a0
 154:	6422                	ld	s0,8(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret

000000000000015a <strlen>:

uint
strlen(const char *s)
{
 15a:	1141                	addi	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 160:	00054783          	lbu	a5,0(a0)
 164:	cf91                	beqz	a5,180 <strlen+0x26>
 166:	0505                	addi	a0,a0,1
 168:	87aa                	mv	a5,a0
 16a:	4685                	li	a3,1
 16c:	9e89                	subw	a3,a3,a0
 16e:	00f6853b          	addw	a0,a3,a5
 172:	0785                	addi	a5,a5,1
 174:	fff7c703          	lbu	a4,-1(a5)
 178:	fb7d                	bnez	a4,16e <strlen+0x14>
    ;
  return n;
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret
  for(n = 0; s[n]; n++)
 180:	4501                	li	a0,0
 182:	bfe5                	j	17a <strlen+0x20>

0000000000000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	1141                	addi	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18a:	ca19                	beqz	a2,1a0 <memset+0x1c>
 18c:	87aa                	mv	a5,a0
 18e:	1602                	slli	a2,a2,0x20
 190:	9201                	srli	a2,a2,0x20
 192:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19a:	0785                	addi	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x12>
  }
  return dst;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strchr>:

char*
strchr(const char *s, char c)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cb99                	beqz	a5,1c6 <strchr+0x20>
    if(*s == c)
 1b2:	00f58763          	beq	a1,a5,1c0 <strchr+0x1a>
  for(; *s; s++)
 1b6:	0505                	addi	a0,a0,1
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbfd                	bnez	a5,1b2 <strchr+0xc>
      return (char*)s;
  return 0;
 1be:	4501                	li	a0,0
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	addi	sp,sp,16
 1c4:	8082                	ret
  return 0;
 1c6:	4501                	li	a0,0
 1c8:	bfe5                	j	1c0 <strchr+0x1a>

00000000000001ca <gets>:

char*
gets(char *buf, int max)
{
 1ca:	711d                	addi	sp,sp,-96
 1cc:	ec86                	sd	ra,88(sp)
 1ce:	e8a2                	sd	s0,80(sp)
 1d0:	e4a6                	sd	s1,72(sp)
 1d2:	e0ca                	sd	s2,64(sp)
 1d4:	fc4e                	sd	s3,56(sp)
 1d6:	f852                	sd	s4,48(sp)
 1d8:	f456                	sd	s5,40(sp)
 1da:	f05a                	sd	s6,32(sp)
 1dc:	ec5e                	sd	s7,24(sp)
 1de:	1080                	addi	s0,sp,96
 1e0:	8baa                	mv	s7,a0
 1e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	892a                	mv	s2,a0
 1e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e8:	4aa9                	li	s5,10
 1ea:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ec:	89a6                	mv	s3,s1
 1ee:	2485                	addiw	s1,s1,1
 1f0:	0344d863          	bge	s1,s4,220 <gets+0x56>
    cc = read(0, &c, 1);
 1f4:	4605                	li	a2,1
 1f6:	faf40593          	addi	a1,s0,-81
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	19a080e7          	jalr	410(ra) # 396 <read>
    if(cc < 1)
 204:	00a05e63          	blez	a0,220 <gets+0x56>
    buf[i++] = c;
 208:	faf44783          	lbu	a5,-81(s0)
 20c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 210:	01578763          	beq	a5,s5,21e <gets+0x54>
 214:	0905                	addi	s2,s2,1
 216:	fd679be3          	bne	a5,s6,1ec <gets+0x22>
  for(i=0; i+1 < max; ){
 21a:	89a6                	mv	s3,s1
 21c:	a011                	j	220 <gets+0x56>
 21e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 220:	99de                	add	s3,s3,s7
 222:	00098023          	sb	zero,0(s3)
  return buf;
}
 226:	855e                	mv	a0,s7
 228:	60e6                	ld	ra,88(sp)
 22a:	6446                	ld	s0,80(sp)
 22c:	64a6                	ld	s1,72(sp)
 22e:	6906                	ld	s2,64(sp)
 230:	79e2                	ld	s3,56(sp)
 232:	7a42                	ld	s4,48(sp)
 234:	7aa2                	ld	s5,40(sp)
 236:	7b02                	ld	s6,32(sp)
 238:	6be2                	ld	s7,24(sp)
 23a:	6125                	addi	sp,sp,96
 23c:	8082                	ret

000000000000023e <stat>:

int
stat(const char *n, struct stat *st)
{
 23e:	1101                	addi	sp,sp,-32
 240:	ec06                	sd	ra,24(sp)
 242:	e822                	sd	s0,16(sp)
 244:	e426                	sd	s1,8(sp)
 246:	e04a                	sd	s2,0(sp)
 248:	1000                	addi	s0,sp,32
 24a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24c:	4581                	li	a1,0
 24e:	00000097          	auipc	ra,0x0
 252:	170080e7          	jalr	368(ra) # 3be <open>
  if(fd < 0)
 256:	02054563          	bltz	a0,280 <stat+0x42>
 25a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25c:	85ca                	mv	a1,s2
 25e:	00000097          	auipc	ra,0x0
 262:	178080e7          	jalr	376(ra) # 3d6 <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	00000097          	auipc	ra,0x0
 26e:	13c080e7          	jalr	316(ra) # 3a6 <close>
  return r;
}
 272:	854a                	mv	a0,s2
 274:	60e2                	ld	ra,24(sp)
 276:	6442                	ld	s0,16(sp)
 278:	64a2                	ld	s1,8(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	addi	sp,sp,32
 27e:	8082                	ret
    return -1;
 280:	597d                	li	s2,-1
 282:	bfc5                	j	272 <stat+0x34>

0000000000000284 <atoi>:

int
atoi(const char *s)
{
 284:	1141                	addi	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 28a:	00054683          	lbu	a3,0(a0)
 28e:	fd06879b          	addiw	a5,a3,-48
 292:	0ff7f793          	zext.b	a5,a5
 296:	4625                	li	a2,9
 298:	02f66863          	bltu	a2,a5,2c8 <atoi+0x44>
 29c:	872a                	mv	a4,a0
  n = 0;
 29e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a0:	0705                	addi	a4,a4,1
 2a2:	0025179b          	slliw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	slliw	a5,a5,0x1
 2ac:	9fb5                	addw	a5,a5,a3
 2ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b2:	00074683          	lbu	a3,0(a4)
 2b6:	fd06879b          	addiw	a5,a3,-48
 2ba:	0ff7f793          	zext.b	a5,a5
 2be:	fef671e3          	bgeu	a2,a5,2a0 <atoi+0x1c>
  return n;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
  n = 0;
 2c8:	4501                	li	a0,0
 2ca:	bfe5                	j	2c2 <atoi+0x3e>

00000000000002cc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d2:	02b57463          	bgeu	a0,a1,2fa <memmove+0x2e>
    while(n-- > 0)
 2d6:	00c05f63          	blez	a2,2f4 <memmove+0x28>
 2da:	1602                	slli	a2,a2,0x20
 2dc:	9201                	srli	a2,a2,0x20
 2de:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e4:	0585                	addi	a1,a1,1
 2e6:	0705                	addi	a4,a4,1
 2e8:	fff5c683          	lbu	a3,-1(a1)
 2ec:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2f0:	fee79ae3          	bne	a5,a4,2e4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret
    dst += n;
 2fa:	00c50733          	add	a4,a0,a2
    src += n;
 2fe:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 300:	fec05ae3          	blez	a2,2f4 <memmove+0x28>
 304:	fff6079b          	addiw	a5,a2,-1
 308:	1782                	slli	a5,a5,0x20
 30a:	9381                	srli	a5,a5,0x20
 30c:	fff7c793          	not	a5,a5
 310:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 312:	15fd                	addi	a1,a1,-1
 314:	177d                	addi	a4,a4,-1
 316:	0005c683          	lbu	a3,0(a1)
 31a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 31e:	fee79ae3          	bne	a5,a4,312 <memmove+0x46>
 322:	bfc9                	j	2f4 <memmove+0x28>

0000000000000324 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e422                	sd	s0,8(sp)
 328:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 32a:	ca05                	beqz	a2,35a <memcmp+0x36>
 32c:	fff6069b          	addiw	a3,a2,-1
 330:	1682                	slli	a3,a3,0x20
 332:	9281                	srli	a3,a3,0x20
 334:	0685                	addi	a3,a3,1
 336:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 338:	00054783          	lbu	a5,0(a0)
 33c:	0005c703          	lbu	a4,0(a1)
 340:	00e79863          	bne	a5,a4,350 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 344:	0505                	addi	a0,a0,1
    p2++;
 346:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 348:	fed518e3          	bne	a0,a3,338 <memcmp+0x14>
  }
  return 0;
 34c:	4501                	li	a0,0
 34e:	a019                	j	354 <memcmp+0x30>
      return *p1 - *p2;
 350:	40e7853b          	subw	a0,a5,a4
}
 354:	6422                	ld	s0,8(sp)
 356:	0141                	addi	sp,sp,16
 358:	8082                	ret
  return 0;
 35a:	4501                	li	a0,0
 35c:	bfe5                	j	354 <memcmp+0x30>

000000000000035e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e406                	sd	ra,8(sp)
 362:	e022                	sd	s0,0(sp)
 364:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 366:	00000097          	auipc	ra,0x0
 36a:	f66080e7          	jalr	-154(ra) # 2cc <memmove>
}
 36e:	60a2                	ld	ra,8(sp)
 370:	6402                	ld	s0,0(sp)
 372:	0141                	addi	sp,sp,16
 374:	8082                	ret

0000000000000376 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 376:	4885                	li	a7,1
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <exit>:
.global exit
exit:
 li a7, SYS_exit
 37e:	4889                	li	a7,2
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <wait>:
.global wait
wait:
 li a7, SYS_wait
 386:	488d                	li	a7,3
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38e:	4891                	li	a7,4
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <read>:
.global read
read:
 li a7, SYS_read
 396:	4895                	li	a7,5
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <write>:
.global write
write:
 li a7, SYS_write
 39e:	48c1                	li	a7,16
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <close>:
.global close
close:
 li a7, SYS_close
 3a6:	48d5                	li	a7,21
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ae:	4899                	li	a7,6
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b6:	489d                	li	a7,7
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <open>:
.global open
open:
 li a7, SYS_open
 3be:	48bd                	li	a7,15
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c6:	48c5                	li	a7,17
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ce:	48c9                	li	a7,18
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d6:	48a1                	li	a7,8
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <link>:
.global link
link:
 li a7, SYS_link
 3de:	48cd                	li	a7,19
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e6:	48d1                	li	a7,20
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ee:	48a5                	li	a7,9
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f6:	48a9                	li	a7,10
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fe:	48ad                	li	a7,11
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 406:	48b1                	li	a7,12
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 40e:	48b5                	li	a7,13
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 416:	48b9                	li	a7,14
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 41e:	48d9                	li	a7,22
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 426:	48dd                	li	a7,23
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 42e:	48e1                	li	a7,24
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 436:	48e5                	li	a7,25
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43e:	1101                	addi	sp,sp,-32
 440:	ec06                	sd	ra,24(sp)
 442:	e822                	sd	s0,16(sp)
 444:	1000                	addi	s0,sp,32
 446:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44a:	4605                	li	a2,1
 44c:	fef40593          	addi	a1,s0,-17
 450:	00000097          	auipc	ra,0x0
 454:	f4e080e7          	jalr	-178(ra) # 39e <write>
}
 458:	60e2                	ld	ra,24(sp)
 45a:	6442                	ld	s0,16(sp)
 45c:	6105                	addi	sp,sp,32
 45e:	8082                	ret

0000000000000460 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 460:	7139                	addi	sp,sp,-64
 462:	fc06                	sd	ra,56(sp)
 464:	f822                	sd	s0,48(sp)
 466:	f426                	sd	s1,40(sp)
 468:	f04a                	sd	s2,32(sp)
 46a:	ec4e                	sd	s3,24(sp)
 46c:	0080                	addi	s0,sp,64
 46e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 470:	c299                	beqz	a3,476 <printint+0x16>
 472:	0805c963          	bltz	a1,504 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 476:	2581                	sext.w	a1,a1
  neg = 0;
 478:	4881                	li	a7,0
 47a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 47e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 480:	2601                	sext.w	a2,a2
 482:	00000517          	auipc	a0,0x0
 486:	75650513          	addi	a0,a0,1878 # bd8 <digits>
 48a:	883a                	mv	a6,a4
 48c:	2705                	addiw	a4,a4,1
 48e:	02c5f7bb          	remuw	a5,a1,a2
 492:	1782                	slli	a5,a5,0x20
 494:	9381                	srli	a5,a5,0x20
 496:	97aa                	add	a5,a5,a0
 498:	0007c783          	lbu	a5,0(a5)
 49c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4a0:	0005879b          	sext.w	a5,a1
 4a4:	02c5d5bb          	divuw	a1,a1,a2
 4a8:	0685                	addi	a3,a3,1
 4aa:	fec7f0e3          	bgeu	a5,a2,48a <printint+0x2a>
  if(neg)
 4ae:	00088c63          	beqz	a7,4c6 <printint+0x66>
    buf[i++] = '-';
 4b2:	fd070793          	addi	a5,a4,-48
 4b6:	00878733          	add	a4,a5,s0
 4ba:	02d00793          	li	a5,45
 4be:	fef70823          	sb	a5,-16(a4)
 4c2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4c6:	02e05863          	blez	a4,4f6 <printint+0x96>
 4ca:	fc040793          	addi	a5,s0,-64
 4ce:	00e78933          	add	s2,a5,a4
 4d2:	fff78993          	addi	s3,a5,-1
 4d6:	99ba                	add	s3,s3,a4
 4d8:	377d                	addiw	a4,a4,-1
 4da:	1702                	slli	a4,a4,0x20
 4dc:	9301                	srli	a4,a4,0x20
 4de:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e2:	fff94583          	lbu	a1,-1(s2)
 4e6:	8526                	mv	a0,s1
 4e8:	00000097          	auipc	ra,0x0
 4ec:	f56080e7          	jalr	-170(ra) # 43e <putc>
  while(--i >= 0)
 4f0:	197d                	addi	s2,s2,-1
 4f2:	ff3918e3          	bne	s2,s3,4e2 <printint+0x82>
}
 4f6:	70e2                	ld	ra,56(sp)
 4f8:	7442                	ld	s0,48(sp)
 4fa:	74a2                	ld	s1,40(sp)
 4fc:	7902                	ld	s2,32(sp)
 4fe:	69e2                	ld	s3,24(sp)
 500:	6121                	addi	sp,sp,64
 502:	8082                	ret
    x = -xx;
 504:	40b005bb          	negw	a1,a1
    neg = 1;
 508:	4885                	li	a7,1
    x = -xx;
 50a:	bf85                	j	47a <printint+0x1a>

000000000000050c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 50c:	7119                	addi	sp,sp,-128
 50e:	fc86                	sd	ra,120(sp)
 510:	f8a2                	sd	s0,112(sp)
 512:	f4a6                	sd	s1,104(sp)
 514:	f0ca                	sd	s2,96(sp)
 516:	ecce                	sd	s3,88(sp)
 518:	e8d2                	sd	s4,80(sp)
 51a:	e4d6                	sd	s5,72(sp)
 51c:	e0da                	sd	s6,64(sp)
 51e:	fc5e                	sd	s7,56(sp)
 520:	f862                	sd	s8,48(sp)
 522:	f466                	sd	s9,40(sp)
 524:	f06a                	sd	s10,32(sp)
 526:	ec6e                	sd	s11,24(sp)
 528:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52a:	0005c903          	lbu	s2,0(a1)
 52e:	18090f63          	beqz	s2,6cc <vprintf+0x1c0>
 532:	8aaa                	mv	s5,a0
 534:	8b32                	mv	s6,a2
 536:	00158493          	addi	s1,a1,1
  state = 0;
 53a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 53c:	02500a13          	li	s4,37
 540:	4c55                	li	s8,21
 542:	00000c97          	auipc	s9,0x0
 546:	63ec8c93          	addi	s9,s9,1598 # b80 <ithread_join+0xcc>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 54a:	02800d93          	li	s11,40
  putc(fd, 'x');
 54e:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 550:	00000b97          	auipc	s7,0x0
 554:	688b8b93          	addi	s7,s7,1672 # bd8 <digits>
 558:	a839                	j	576 <vprintf+0x6a>
        putc(fd, c);
 55a:	85ca                	mv	a1,s2
 55c:	8556                	mv	a0,s5
 55e:	00000097          	auipc	ra,0x0
 562:	ee0080e7          	jalr	-288(ra) # 43e <putc>
 566:	a019                	j	56c <vprintf+0x60>
    } else if(state == '%'){
 568:	01498d63          	beq	s3,s4,582 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 56c:	0485                	addi	s1,s1,1
 56e:	fff4c903          	lbu	s2,-1(s1)
 572:	14090d63          	beqz	s2,6cc <vprintf+0x1c0>
    if(state == 0){
 576:	fe0999e3          	bnez	s3,568 <vprintf+0x5c>
      if(c == '%'){
 57a:	ff4910e3          	bne	s2,s4,55a <vprintf+0x4e>
        state = '%';
 57e:	89d2                	mv	s3,s4
 580:	b7f5                	j	56c <vprintf+0x60>
      if(c == 'd'){
 582:	11490c63          	beq	s2,s4,69a <vprintf+0x18e>
 586:	f9d9079b          	addiw	a5,s2,-99
 58a:	0ff7f793          	zext.b	a5,a5
 58e:	10fc6e63          	bltu	s8,a5,6aa <vprintf+0x19e>
 592:	f9d9079b          	addiw	a5,s2,-99
 596:	0ff7f713          	zext.b	a4,a5
 59a:	10ec6863          	bltu	s8,a4,6aa <vprintf+0x19e>
 59e:	00271793          	slli	a5,a4,0x2
 5a2:	97e6                	add	a5,a5,s9
 5a4:	439c                	lw	a5,0(a5)
 5a6:	97e6                	add	a5,a5,s9
 5a8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5aa:	008b0913          	addi	s2,s6,8
 5ae:	4685                	li	a3,1
 5b0:	4629                	li	a2,10
 5b2:	000b2583          	lw	a1,0(s6)
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	ea8080e7          	jalr	-344(ra) # 460 <printint>
 5c0:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b765                	j	56c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c6:	008b0913          	addi	s2,s6,8
 5ca:	4681                	li	a3,0
 5cc:	4629                	li	a2,10
 5ce:	000b2583          	lw	a1,0(s6)
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	e8c080e7          	jalr	-372(ra) # 460 <printint>
 5dc:	8b4a                	mv	s6,s2
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	b771                	j	56c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5e2:	008b0913          	addi	s2,s6,8
 5e6:	4681                	li	a3,0
 5e8:	866a                	mv	a2,s10
 5ea:	000b2583          	lw	a1,0(s6)
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	e70080e7          	jalr	-400(ra) # 460 <printint>
 5f8:	8b4a                	mv	s6,s2
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	bf85                	j	56c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5fe:	008b0793          	addi	a5,s6,8
 602:	f8f43423          	sd	a5,-120(s0)
 606:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 60a:	03000593          	li	a1,48
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	e2e080e7          	jalr	-466(ra) # 43e <putc>
  putc(fd, 'x');
 618:	07800593          	li	a1,120
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	e20080e7          	jalr	-480(ra) # 43e <putc>
 626:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 628:	03c9d793          	srli	a5,s3,0x3c
 62c:	97de                	add	a5,a5,s7
 62e:	0007c583          	lbu	a1,0(a5)
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	e0a080e7          	jalr	-502(ra) # 43e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 63c:	0992                	slli	s3,s3,0x4
 63e:	397d                	addiw	s2,s2,-1
 640:	fe0914e3          	bnez	s2,628 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 644:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 648:	4981                	li	s3,0
 64a:	b70d                	j	56c <vprintf+0x60>
        s = va_arg(ap, char*);
 64c:	008b0913          	addi	s2,s6,8
 650:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 654:	02098163          	beqz	s3,676 <vprintf+0x16a>
        while(*s != 0){
 658:	0009c583          	lbu	a1,0(s3)
 65c:	c5ad                	beqz	a1,6c6 <vprintf+0x1ba>
          putc(fd, *s);
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	dde080e7          	jalr	-546(ra) # 43e <putc>
          s++;
 668:	0985                	addi	s3,s3,1
        while(*s != 0){
 66a:	0009c583          	lbu	a1,0(s3)
 66e:	f9e5                	bnez	a1,65e <vprintf+0x152>
        s = va_arg(ap, char*);
 670:	8b4a                	mv	s6,s2
      state = 0;
 672:	4981                	li	s3,0
 674:	bde5                	j	56c <vprintf+0x60>
          s = "(null)";
 676:	00000997          	auipc	s3,0x0
 67a:	50298993          	addi	s3,s3,1282 # b78 <ithread_join+0xc4>
        while(*s != 0){
 67e:	85ee                	mv	a1,s11
 680:	bff9                	j	65e <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 682:	008b0913          	addi	s2,s6,8
 686:	000b4583          	lbu	a1,0(s6)
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	db2080e7          	jalr	-590(ra) # 43e <putc>
 694:	8b4a                	mv	s6,s2
      state = 0;
 696:	4981                	li	s3,0
 698:	bdd1                	j	56c <vprintf+0x60>
        putc(fd, c);
 69a:	85d2                	mv	a1,s4
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	da0080e7          	jalr	-608(ra) # 43e <putc>
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b5d1                	j	56c <vprintf+0x60>
        putc(fd, '%');
 6aa:	85d2                	mv	a1,s4
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	d90080e7          	jalr	-624(ra) # 43e <putc>
        putc(fd, c);
 6b6:	85ca                	mv	a1,s2
 6b8:	8556                	mv	a0,s5
 6ba:	00000097          	auipc	ra,0x0
 6be:	d84080e7          	jalr	-636(ra) # 43e <putc>
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b565                	j	56c <vprintf+0x60>
        s = va_arg(ap, char*);
 6c6:	8b4a                	mv	s6,s2
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b54d                	j	56c <vprintf+0x60>
    }
  }
}
 6cc:	70e6                	ld	ra,120(sp)
 6ce:	7446                	ld	s0,112(sp)
 6d0:	74a6                	ld	s1,104(sp)
 6d2:	7906                	ld	s2,96(sp)
 6d4:	69e6                	ld	s3,88(sp)
 6d6:	6a46                	ld	s4,80(sp)
 6d8:	6aa6                	ld	s5,72(sp)
 6da:	6b06                	ld	s6,64(sp)
 6dc:	7be2                	ld	s7,56(sp)
 6de:	7c42                	ld	s8,48(sp)
 6e0:	7ca2                	ld	s9,40(sp)
 6e2:	7d02                	ld	s10,32(sp)
 6e4:	6de2                	ld	s11,24(sp)
 6e6:	6109                	addi	sp,sp,128
 6e8:	8082                	ret

00000000000006ea <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ea:	715d                	addi	sp,sp,-80
 6ec:	ec06                	sd	ra,24(sp)
 6ee:	e822                	sd	s0,16(sp)
 6f0:	1000                	addi	s0,sp,32
 6f2:	e010                	sd	a2,0(s0)
 6f4:	e414                	sd	a3,8(s0)
 6f6:	e818                	sd	a4,16(s0)
 6f8:	ec1c                	sd	a5,24(s0)
 6fa:	03043023          	sd	a6,32(s0)
 6fe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 702:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 706:	8622                	mv	a2,s0
 708:	00000097          	auipc	ra,0x0
 70c:	e04080e7          	jalr	-508(ra) # 50c <vprintf>
}
 710:	60e2                	ld	ra,24(sp)
 712:	6442                	ld	s0,16(sp)
 714:	6161                	addi	sp,sp,80
 716:	8082                	ret

0000000000000718 <printf>:

void
printf(const char *fmt, ...)
{
 718:	711d                	addi	sp,sp,-96
 71a:	ec06                	sd	ra,24(sp)
 71c:	e822                	sd	s0,16(sp)
 71e:	1000                	addi	s0,sp,32
 720:	e40c                	sd	a1,8(s0)
 722:	e810                	sd	a2,16(s0)
 724:	ec14                	sd	a3,24(s0)
 726:	f018                	sd	a4,32(s0)
 728:	f41c                	sd	a5,40(s0)
 72a:	03043823          	sd	a6,48(s0)
 72e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 732:	00840613          	addi	a2,s0,8
 736:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 73a:	85aa                	mv	a1,a0
 73c:	4505                	li	a0,1
 73e:	00000097          	auipc	ra,0x0
 742:	dce080e7          	jalr	-562(ra) # 50c <vprintf>
}
 746:	60e2                	ld	ra,24(sp)
 748:	6442                	ld	s0,16(sp)
 74a:	6125                	addi	sp,sp,96
 74c:	8082                	ret

000000000000074e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74e:	1141                	addi	sp,sp,-16
 750:	e422                	sd	s0,8(sp)
 752:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 754:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	00001797          	auipc	a5,0x1
 75c:	8c87b783          	ld	a5,-1848(a5) # 1020 <freep>
 760:	a02d                	j	78a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 762:	4618                	lw	a4,8(a2)
 764:	9f2d                	addw	a4,a4,a1
 766:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 76a:	6398                	ld	a4,0(a5)
 76c:	6310                	ld	a2,0(a4)
 76e:	a83d                	j	7ac <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 770:	ff852703          	lw	a4,-8(a0)
 774:	9f31                	addw	a4,a4,a2
 776:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 778:	ff053683          	ld	a3,-16(a0)
 77c:	a091                	j	7c0 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	6398                	ld	a4,0(a5)
 780:	00e7e463          	bltu	a5,a4,788 <free+0x3a>
 784:	00e6ea63          	bltu	a3,a4,798 <free+0x4a>
{
 788:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78a:	fed7fae3          	bgeu	a5,a3,77e <free+0x30>
 78e:	6398                	ld	a4,0(a5)
 790:	00e6e463          	bltu	a3,a4,798 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	fee7eae3          	bltu	a5,a4,788 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 798:	ff852583          	lw	a1,-8(a0)
 79c:	6390                	ld	a2,0(a5)
 79e:	02059813          	slli	a6,a1,0x20
 7a2:	01c85713          	srli	a4,a6,0x1c
 7a6:	9736                	add	a4,a4,a3
 7a8:	fae60de3          	beq	a2,a4,762 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7ac:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b0:	4790                	lw	a2,8(a5)
 7b2:	02061593          	slli	a1,a2,0x20
 7b6:	01c5d713          	srli	a4,a1,0x1c
 7ba:	973e                	add	a4,a4,a5
 7bc:	fae68ae3          	beq	a3,a4,770 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7c0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c2:	00001717          	auipc	a4,0x1
 7c6:	84f73f23          	sd	a5,-1954(a4) # 1020 <freep>
}
 7ca:	6422                	ld	s0,8(sp)
 7cc:	0141                	addi	sp,sp,16
 7ce:	8082                	ret

00000000000007d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d0:	7139                	addi	sp,sp,-64
 7d2:	fc06                	sd	ra,56(sp)
 7d4:	f822                	sd	s0,48(sp)
 7d6:	f426                	sd	s1,40(sp)
 7d8:	f04a                	sd	s2,32(sp)
 7da:	ec4e                	sd	s3,24(sp)
 7dc:	e852                	sd	s4,16(sp)
 7de:	e456                	sd	s5,8(sp)
 7e0:	e05a                	sd	s6,0(sp)
 7e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e4:	02051493          	slli	s1,a0,0x20
 7e8:	9081                	srli	s1,s1,0x20
 7ea:	04bd                	addi	s1,s1,15
 7ec:	8091                	srli	s1,s1,0x4
 7ee:	0014899b          	addiw	s3,s1,1
 7f2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7f4:	00001517          	auipc	a0,0x1
 7f8:	82c53503          	ld	a0,-2004(a0) # 1020 <freep>
 7fc:	c515                	beqz	a0,828 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 800:	4798                	lw	a4,8(a5)
 802:	02977f63          	bgeu	a4,s1,840 <malloc+0x70>
 806:	8a4e                	mv	s4,s3
 808:	0009871b          	sext.w	a4,s3
 80c:	6685                	lui	a3,0x1
 80e:	00d77363          	bgeu	a4,a3,814 <malloc+0x44>
 812:	6a05                	lui	s4,0x1
 814:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 818:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 81c:	00001917          	auipc	s2,0x1
 820:	80490913          	addi	s2,s2,-2044 # 1020 <freep>
  if(p == (char*)-1)
 824:	5afd                	li	s5,-1
 826:	a895                	j	89a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 828:	00001797          	auipc	a5,0x1
 82c:	81878793          	addi	a5,a5,-2024 # 1040 <base>
 830:	00000717          	auipc	a4,0x0
 834:	7ef73823          	sd	a5,2032(a4) # 1020 <freep>
 838:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 83a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 83e:	b7e1                	j	806 <malloc+0x36>
      if(p->s.size == nunits)
 840:	02e48c63          	beq	s1,a4,878 <malloc+0xa8>
        p->s.size -= nunits;
 844:	4137073b          	subw	a4,a4,s3
 848:	c798                	sw	a4,8(a5)
        p += p->s.size;
 84a:	02071693          	slli	a3,a4,0x20
 84e:	01c6d713          	srli	a4,a3,0x1c
 852:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 854:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 858:	00000717          	auipc	a4,0x0
 85c:	7ca73423          	sd	a0,1992(a4) # 1020 <freep>
      return (void*)(p + 1);
 860:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 864:	70e2                	ld	ra,56(sp)
 866:	7442                	ld	s0,48(sp)
 868:	74a2                	ld	s1,40(sp)
 86a:	7902                	ld	s2,32(sp)
 86c:	69e2                	ld	s3,24(sp)
 86e:	6a42                	ld	s4,16(sp)
 870:	6aa2                	ld	s5,8(sp)
 872:	6b02                	ld	s6,0(sp)
 874:	6121                	addi	sp,sp,64
 876:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 878:	6398                	ld	a4,0(a5)
 87a:	e118                	sd	a4,0(a0)
 87c:	bff1                	j	858 <malloc+0x88>
  hp->s.size = nu;
 87e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 882:	0541                	addi	a0,a0,16
 884:	00000097          	auipc	ra,0x0
 888:	eca080e7          	jalr	-310(ra) # 74e <free>
  return freep;
 88c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 890:	d971                	beqz	a0,864 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 894:	4798                	lw	a4,8(a5)
 896:	fa9775e3          	bgeu	a4,s1,840 <malloc+0x70>
    if(p == freep)
 89a:	00093703          	ld	a4,0(s2)
 89e:	853e                	mv	a0,a5
 8a0:	fef719e3          	bne	a4,a5,892 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8a4:	8552                	mv	a0,s4
 8a6:	00000097          	auipc	ra,0x0
 8aa:	b60080e7          	jalr	-1184(ra) # 406 <sbrk>
  if(p == (char*)-1)
 8ae:	fd5518e3          	bne	a0,s5,87e <malloc+0xae>
        return 0;
 8b2:	4501                	li	a0,0
 8b4:	bf45                	j	864 <malloc+0x94>

00000000000008b6 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 8b6:	1141                	addi	sp,sp,-16
 8b8:	e406                	sd	ra,8(sp)
 8ba:	e022                	sd	s0,0(sp)
 8bc:	0800                	addi	s0,sp,16
  thread_exit(status);
 8be:	00000097          	auipc	ra,0x0
 8c2:	b78080e7          	jalr	-1160(ra) # 436 <thread_exit>
}
 8c6:	60a2                	ld	ra,8(sp)
 8c8:	6402                	ld	s0,0(sp)
 8ca:	0141                	addi	sp,sp,16
 8cc:	8082                	ret

00000000000008ce <free_stacks>:
int free_stacks() {
 8ce:	7179                	addi	sp,sp,-48
 8d0:	f406                	sd	ra,40(sp)
 8d2:	f022                	sd	s0,32(sp)
 8d4:	ec26                	sd	s1,24(sp)
 8d6:	e84a                	sd	s2,16(sp)
 8d8:	e44e                	sd	s3,8(sp)
 8da:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 8dc:	00000797          	auipc	a5,0x0
 8e0:	7547a783          	lw	a5,1876(a5) # 1030 <num_threads>
 8e4:	02f05c63          	blez	a5,91c <free_stacks+0x4e>
 8e8:	4481                	li	s1,0
    free(stacks[i]);
 8ea:	00000997          	auipc	s3,0x0
 8ee:	73e98993          	addi	s3,s3,1854 # 1028 <stacks>
  for (int i = 0; i < num_threads; i++) {
 8f2:	00000917          	auipc	s2,0x0
 8f6:	73e90913          	addi	s2,s2,1854 # 1030 <num_threads>
    free(stacks[i]);
 8fa:	0009b783          	ld	a5,0(s3)
 8fe:	00349713          	slli	a4,s1,0x3
 902:	97ba                	add	a5,a5,a4
 904:	6388                	ld	a0,0(a5)
 906:	00000097          	auipc	ra,0x0
 90a:	e48080e7          	jalr	-440(ra) # 74e <free>
  for (int i = 0; i < num_threads; i++) {
 90e:	0485                	addi	s1,s1,1
 910:	00092703          	lw	a4,0(s2)
 914:	0004879b          	sext.w	a5,s1
 918:	fee7c1e3          	blt	a5,a4,8fa <free_stacks+0x2c>
  free(stacks);
 91c:	00000497          	auipc	s1,0x0
 920:	70c48493          	addi	s1,s1,1804 # 1028 <stacks>
 924:	6088                	ld	a0,0(s1)
 926:	00000097          	auipc	ra,0x0
 92a:	e28080e7          	jalr	-472(ra) # 74e <free>
  stacks = 0;
 92e:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 932:	00000797          	auipc	a5,0x0
 936:	6e07af23          	sw	zero,1790(a5) # 1030 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 93a:	47a1                	li	a5,8
 93c:	00000717          	auipc	a4,0x0
 940:	6cf72223          	sw	a5,1732(a4) # 1000 <max_stacks>
  threads_done = 0;
 944:	00000797          	auipc	a5,0x0
 948:	6e07a823          	sw	zero,1776(a5) # 1034 <threads_done>
}
 94c:	4501                	li	a0,0
 94e:	70a2                	ld	ra,40(sp)
 950:	7402                	ld	s0,32(sp)
 952:	64e2                	ld	s1,24(sp)
 954:	6942                	ld	s2,16(sp)
 956:	69a2                	ld	s3,8(sp)
 958:	6145                	addi	sp,sp,48
 95a:	8082                	ret

000000000000095c <expand_num_threads>:
int expand_num_threads() {
 95c:	1101                	addi	sp,sp,-32
 95e:	ec06                	sd	ra,24(sp)
 960:	e822                	sd	s0,16(sp)
 962:	e426                	sd	s1,8(sp)
 964:	e04a                	sd	s2,0(sp)
 966:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 968:	00000797          	auipc	a5,0x0
 96c:	69878793          	addi	a5,a5,1688 # 1000 <max_stacks>
 970:	4388                	lw	a0,0(a5)
 972:	0015151b          	slliw	a0,a0,0x1
 976:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 978:	0035151b          	slliw	a0,a0,0x3
 97c:	00000097          	auipc	ra,0x0
 980:	e54080e7          	jalr	-428(ra) # 7d0 <malloc>
 984:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 986:	00000617          	auipc	a2,0x0
 98a:	6aa62603          	lw	a2,1706(a2) # 1030 <num_threads>
 98e:	00000497          	auipc	s1,0x0
 992:	69a48493          	addi	s1,s1,1690 # 1028 <stacks>
 996:	0036161b          	slliw	a2,a2,0x3
 99a:	608c                	ld	a1,0(s1)
 99c:	00000097          	auipc	ra,0x0
 9a0:	930080e7          	jalr	-1744(ra) # 2cc <memmove>
  free(stacks);
 9a4:	6088                	ld	a0,0(s1)
 9a6:	00000097          	auipc	ra,0x0
 9aa:	da8080e7          	jalr	-600(ra) # 74e <free>
  stacks = new_stacks;
 9ae:	0124b023          	sd	s2,0(s1)
}
 9b2:	4501                	li	a0,0
 9b4:	60e2                	ld	ra,24(sp)
 9b6:	6442                	ld	s0,16(sp)
 9b8:	64a2                	ld	s1,8(sp)
 9ba:	6902                	ld	s2,0(sp)
 9bc:	6105                	addi	sp,sp,32
 9be:	8082                	ret

00000000000009c0 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 9c0:	7179                	addi	sp,sp,-48
 9c2:	f406                	sd	ra,40(sp)
 9c4:	f022                	sd	s0,32(sp)
 9c6:	ec26                	sd	s1,24(sp)
 9c8:	e84a                	sd	s2,16(sp)
 9ca:	e44e                	sd	s3,8(sp)
 9cc:	1800                	addi	s0,sp,48
 9ce:	892a                	mv	s2,a0
 9d0:	89ae                	mv	s3,a1
  if (stacks == 0) {
 9d2:	00000797          	auipc	a5,0x0
 9d6:	6567b783          	ld	a5,1622(a5) # 1028 <stacks>
 9da:	c3d1                	beqz	a5,a5e <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 9dc:	00000797          	auipc	a5,0x0
 9e0:	6247a783          	lw	a5,1572(a5) # 1000 <max_stacks>
 9e4:	00000717          	auipc	a4,0x0
 9e8:	64c72703          	lw	a4,1612(a4) # 1030 <num_threads>
 9ec:	00f71a63          	bne	a4,a5,a00 <ithread_create+0x40>
    if (max_stacks == MAX_THREADS) {
 9f0:	04000713          	li	a4,64
 9f4:	08e78463          	beq	a5,a4,a7c <ithread_create+0xbc>
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 9f8:	00000097          	auipc	ra,0x0
 9fc:	f64080e7          	jalr	-156(ra) # 95c <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a00:	6505                	lui	a0,0x1
 a02:	00000097          	auipc	ra,0x0
 a06:	dce080e7          	jalr	-562(ra) # 7d0 <malloc>
 a0a:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a0c:	00000717          	auipc	a4,0x0
 a10:	62472703          	lw	a4,1572(a4) # 1030 <num_threads>
 a14:	070e                	slli	a4,a4,0x3
 a16:	00000797          	auipc	a5,0x0
 a1a:	6127b783          	ld	a5,1554(a5) # 1028 <stacks>
 a1e:	97ba                	add	a5,a5,a4
 a20:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a22:	00000697          	auipc	a3,0x0
 a26:	e9468693          	addi	a3,a3,-364 # 8b6 <ithread_exit>
 a2a:	862a                	mv	a2,a0
 a2c:	85ce                	mv	a1,s3
 a2e:	854a                	mv	a0,s2
 a30:	00000097          	auipc	ra,0x0
 a34:	9f6080e7          	jalr	-1546(ra) # 426 <create_thread>
 a38:	892a                	mv	s2,a0
  if (res != -1) {
 a3a:	57fd                	li	a5,-1
 a3c:	04f50a63          	beq	a0,a5,a90 <ithread_create+0xd0>
    num_threads++;
 a40:	00000717          	auipc	a4,0x0
 a44:	5f070713          	addi	a4,a4,1520 # 1030 <num_threads>
 a48:	431c                	lw	a5,0(a4)
 a4a:	2785                	addiw	a5,a5,1
 a4c:	c31c                	sw	a5,0(a4)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 a4e:	854a                	mv	a0,s2
 a50:	70a2                	ld	ra,40(sp)
 a52:	7402                	ld	s0,32(sp)
 a54:	64e2                	ld	s1,24(sp)
 a56:	6942                	ld	s2,16(sp)
 a58:	69a2                	ld	s3,8(sp)
 a5a:	6145                	addi	sp,sp,48
 a5c:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 a5e:	00000517          	auipc	a0,0x0
 a62:	5a252503          	lw	a0,1442(a0) # 1000 <max_stacks>
 a66:	0035151b          	slliw	a0,a0,0x3
 a6a:	00000097          	auipc	ra,0x0
 a6e:	d66080e7          	jalr	-666(ra) # 7d0 <malloc>
 a72:	00000797          	auipc	a5,0x0
 a76:	5aa7bb23          	sd	a0,1462(a5) # 1028 <stacks>
 a7a:	b78d                	j	9dc <ithread_create+0x1c>
      printf("ERROR: Thread capacity has been reached\n");
 a7c:	00000517          	auipc	a0,0x0
 a80:	17450513          	addi	a0,a0,372 # bf0 <digits+0x18>
 a84:	00000097          	auipc	ra,0x0
 a88:	c94080e7          	jalr	-876(ra) # 718 <printf>
      return -1;
 a8c:	597d                	li	s2,-1
 a8e:	b7c1                	j	a4e <ithread_create+0x8e>
    free(stack_ptr);
 a90:	8526                	mv	a0,s1
 a92:	00000097          	auipc	ra,0x0
 a96:	cbc080e7          	jalr	-836(ra) # 74e <free>
    stacks[num_threads] = 0;
 a9a:	00000717          	auipc	a4,0x0
 a9e:	59672703          	lw	a4,1430(a4) # 1030 <num_threads>
 aa2:	070e                	slli	a4,a4,0x3
 aa4:	00000797          	auipc	a5,0x0
 aa8:	5847b783          	ld	a5,1412(a5) # 1028 <stacks>
 aac:	97ba                	add	a5,a5,a4
 aae:	0007b023          	sd	zero,0(a5)
 ab2:	bf71                	j	a4e <ithread_create+0x8e>

0000000000000ab4 <ithread_join>:

int ithread_join(int thread_id) {
 ab4:	1101                	addi	sp,sp,-32
 ab6:	ec06                	sd	ra,24(sp)
 ab8:	e822                	sd	s0,16(sp)
 aba:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 abc:	fec40593          	addi	a1,s0,-20
 ac0:	00000097          	auipc	ra,0x0
 ac4:	96e080e7          	jalr	-1682(ra) # 42e <join_thread>
  threads_done++;
 ac8:	00000717          	auipc	a4,0x0
 acc:	56c70713          	addi	a4,a4,1388 # 1034 <threads_done>
 ad0:	431c                	lw	a5,0(a4)
 ad2:	2785                	addiw	a5,a5,1
 ad4:	0007869b          	sext.w	a3,a5
 ad8:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 ada:	00000797          	auipc	a5,0x0
 ade:	5567a783          	lw	a5,1366(a5) # 1030 <num_threads>
 ae2:	00d78863          	beq	a5,a3,af2 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 ae6:	fec42503          	lw	a0,-20(s0)
 aea:	60e2                	ld	ra,24(sp)
 aec:	6442                	ld	s0,16(sp)
 aee:	6105                	addi	sp,sp,32
 af0:	8082                	ret
    free_stacks();
 af2:	00000097          	auipc	ra,0x0
 af6:	ddc080e7          	jalr	-548(ra) # 8ce <free_stacks>
 afa:	b7f5                	j	ae6 <ithread_join+0x32>
