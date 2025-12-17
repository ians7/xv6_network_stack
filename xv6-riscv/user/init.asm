
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
  3a:	b5290913          	addi	s2,s2,-1198 # b88 <ithread_join+0x56>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	734080e7          	jalr	1844(ra) # 774 <printf>
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
  6e:	b6e50513          	addi	a0,a0,-1170 # bd8 <ithread_join+0xa6>
  72:	00000097          	auipc	ra,0x0
  76:	702080e7          	jalr	1794(ra) # 774 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	324080e7          	jalr	804(ra) # 3a0 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	af850513          	addi	a0,a0,-1288 # b80 <ithread_join+0x4e>
  90:	00000097          	auipc	ra,0x0
  94:	358080e7          	jalr	856(ra) # 3e8 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	ae650513          	addi	a0,a0,-1306 # b80 <ithread_join+0x4e>
  a2:	00000097          	auipc	ra,0x0
  a6:	33e080e7          	jalr	830(ra) # 3e0 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	af450513          	addi	a0,a0,-1292 # ba0 <ithread_join+0x6e>
  b4:	00000097          	auipc	ra,0x0
  b8:	6c0080e7          	jalr	1728(ra) # 774 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2e2080e7          	jalr	738(ra) # 3a0 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	44a58593          	addi	a1,a1,1098 # 1510 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	aea50513          	addi	a0,a0,-1302 # bb8 <ithread_join+0x86>
  d6:	00000097          	auipc	ra,0x0
  da:	302080e7          	jalr	770(ra) # 3d8 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	ae250513          	addi	a0,a0,-1310 # bc0 <ithread_join+0x8e>
  e6:	00000097          	auipc	ra,0x0
  ea:	68e080e7          	jalr	1678(ra) # 774 <printf>
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

0000000000000488 <send>:
.global send
send:
 li a7, SYS_send
 488:	48fd                	li	a7,31
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <recv>:
.global recv
recv:
 li a7, SYS_recv
 490:	02000893          	li	a7,32
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 49a:	02100893          	li	a7,33
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 4a4:	02200893          	li	a7,34
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ae:	1101                	addi	sp,sp,-32
 4b0:	ec06                	sd	ra,24(sp)
 4b2:	e822                	sd	s0,16(sp)
 4b4:	1000                	addi	s0,sp,32
 4b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ba:	4605                	li	a2,1
 4bc:	fef40593          	addi	a1,s0,-17
 4c0:	00000097          	auipc	ra,0x0
 4c4:	f00080e7          	jalr	-256(ra) # 3c0 <write>
}
 4c8:	60e2                	ld	ra,24(sp)
 4ca:	6442                	ld	s0,16(sp)
 4cc:	6105                	addi	sp,sp,32
 4ce:	8082                	ret

00000000000004d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d0:	7139                	addi	sp,sp,-64
 4d2:	fc06                	sd	ra,56(sp)
 4d4:	f822                	sd	s0,48(sp)
 4d6:	f04a                	sd	s2,32(sp)
 4d8:	ec4e                	sd	s3,24(sp)
 4da:	0080                	addi	s0,sp,64
 4dc:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4de:	cad9                	beqz	a3,574 <printint+0xa4>
 4e0:	01f5d79b          	srliw	a5,a1,0x1f
 4e4:	cbc1                	beqz	a5,574 <printint+0xa4>
    neg = 1;
    x = -xx;
 4e6:	40b005bb          	negw	a1,a1
    neg = 1;
 4ea:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4ec:	fc040993          	addi	s3,s0,-64
  neg = 0;
 4f0:	86ce                	mv	a3,s3
  i = 0;
 4f2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4f4:	00000817          	auipc	a6,0x0
 4f8:	79480813          	addi	a6,a6,1940 # c88 <digits>
 4fc:	88ba                	mv	a7,a4
 4fe:	0017051b          	addiw	a0,a4,1
 502:	872a                	mv	a4,a0
 504:	02c5f7bb          	remuw	a5,a1,a2
 508:	1782                	slli	a5,a5,0x20
 50a:	9381                	srli	a5,a5,0x20
 50c:	97c2                	add	a5,a5,a6
 50e:	0007c783          	lbu	a5,0(a5)
 512:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 516:	87ae                	mv	a5,a1
 518:	02c5d5bb          	divuw	a1,a1,a2
 51c:	0685                	addi	a3,a3,1
 51e:	fcc7ffe3          	bgeu	a5,a2,4fc <printint+0x2c>
  if(neg)
 522:	00030c63          	beqz	t1,53a <printint+0x6a>
    buf[i++] = '-';
 526:	fd050793          	addi	a5,a0,-48
 52a:	00878533          	add	a0,a5,s0
 52e:	02d00793          	li	a5,45
 532:	fef50823          	sb	a5,-16(a0)
 536:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 53a:	02e05763          	blez	a4,568 <printint+0x98>
 53e:	f426                	sd	s1,40(sp)
 540:	377d                	addiw	a4,a4,-1
 542:	00e984b3          	add	s1,s3,a4
 546:	19fd                	addi	s3,s3,-1
 548:	99ba                	add	s3,s3,a4
 54a:	1702                	slli	a4,a4,0x20
 54c:	9301                	srli	a4,a4,0x20
 54e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 552:	0004c583          	lbu	a1,0(s1)
 556:	854a                	mv	a0,s2
 558:	00000097          	auipc	ra,0x0
 55c:	f56080e7          	jalr	-170(ra) # 4ae <putc>
  while(--i >= 0)
 560:	14fd                	addi	s1,s1,-1
 562:	ff3498e3          	bne	s1,s3,552 <printint+0x82>
 566:	74a2                	ld	s1,40(sp)
}
 568:	70e2                	ld	ra,56(sp)
 56a:	7442                	ld	s0,48(sp)
 56c:	7902                	ld	s2,32(sp)
 56e:	69e2                	ld	s3,24(sp)
 570:	6121                	addi	sp,sp,64
 572:	8082                	ret
  neg = 0;
 574:	4301                	li	t1,0
 576:	bf9d                	j	4ec <printint+0x1c>

0000000000000578 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 578:	715d                	addi	sp,sp,-80
 57a:	e486                	sd	ra,72(sp)
 57c:	e0a2                	sd	s0,64(sp)
 57e:	f84a                	sd	s2,48(sp)
 580:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 582:	0005c903          	lbu	s2,0(a1)
 586:	1a090b63          	beqz	s2,73c <vprintf+0x1c4>
 58a:	fc26                	sd	s1,56(sp)
 58c:	f44e                	sd	s3,40(sp)
 58e:	f052                	sd	s4,32(sp)
 590:	ec56                	sd	s5,24(sp)
 592:	e85a                	sd	s6,16(sp)
 594:	e45e                	sd	s7,8(sp)
 596:	8aaa                	mv	s5,a0
 598:	8bb2                	mv	s7,a2
 59a:	00158493          	addi	s1,a1,1
  state = 0;
 59e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5a0:	02500a13          	li	s4,37
 5a4:	4b55                	li	s6,21
 5a6:	a839                	j	5c4 <vprintf+0x4c>
        putc(fd, c);
 5a8:	85ca                	mv	a1,s2
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	f02080e7          	jalr	-254(ra) # 4ae <putc>
 5b4:	a019                	j	5ba <vprintf+0x42>
    } else if(state == '%'){
 5b6:	01498d63          	beq	s3,s4,5d0 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5ba:	0485                	addi	s1,s1,1
 5bc:	fff4c903          	lbu	s2,-1(s1)
 5c0:	16090863          	beqz	s2,730 <vprintf+0x1b8>
    if(state == 0){
 5c4:	fe0999e3          	bnez	s3,5b6 <vprintf+0x3e>
      if(c == '%'){
 5c8:	ff4910e3          	bne	s2,s4,5a8 <vprintf+0x30>
        state = '%';
 5cc:	89d2                	mv	s3,s4
 5ce:	b7f5                	j	5ba <vprintf+0x42>
      if(c == 'd'){
 5d0:	13490563          	beq	s2,s4,6fa <vprintf+0x182>
 5d4:	f9d9079b          	addiw	a5,s2,-99
 5d8:	0ff7f793          	zext.b	a5,a5
 5dc:	12fb6863          	bltu	s6,a5,70c <vprintf+0x194>
 5e0:	f9d9079b          	addiw	a5,s2,-99
 5e4:	0ff7f713          	zext.b	a4,a5
 5e8:	12eb6263          	bltu	s6,a4,70c <vprintf+0x194>
 5ec:	00271793          	slli	a5,a4,0x2
 5f0:	00000717          	auipc	a4,0x0
 5f4:	64070713          	addi	a4,a4,1600 # c30 <ithread_join+0xfe>
 5f8:	97ba                	add	a5,a5,a4
 5fa:	439c                	lw	a5,0(a5)
 5fc:	97ba                	add	a5,a5,a4
 5fe:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 600:	008b8913          	addi	s2,s7,8
 604:	4685                	li	a3,1
 606:	4629                	li	a2,10
 608:	000ba583          	lw	a1,0(s7)
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	ec2080e7          	jalr	-318(ra) # 4d0 <printint>
 616:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 618:	4981                	li	s3,0
 61a:	b745                	j	5ba <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61c:	008b8913          	addi	s2,s7,8
 620:	4681                	li	a3,0
 622:	4629                	li	a2,10
 624:	000ba583          	lw	a1,0(s7)
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	ea6080e7          	jalr	-346(ra) # 4d0 <printint>
 632:	8bca                	mv	s7,s2
      state = 0;
 634:	4981                	li	s3,0
 636:	b751                	j	5ba <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 638:	008b8913          	addi	s2,s7,8
 63c:	4681                	li	a3,0
 63e:	4641                	li	a2,16
 640:	000ba583          	lw	a1,0(s7)
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e8a080e7          	jalr	-374(ra) # 4d0 <printint>
 64e:	8bca                	mv	s7,s2
      state = 0;
 650:	4981                	li	s3,0
 652:	b7a5                	j	5ba <vprintf+0x42>
 654:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 656:	008b8793          	addi	a5,s7,8
 65a:	8c3e                	mv	s8,a5
 65c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 660:	03000593          	li	a1,48
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	e48080e7          	jalr	-440(ra) # 4ae <putc>
  putc(fd, 'x');
 66e:	07800593          	li	a1,120
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	e3a080e7          	jalr	-454(ra) # 4ae <putc>
 67c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67e:	00000b97          	auipc	s7,0x0
 682:	60ab8b93          	addi	s7,s7,1546 # c88 <digits>
 686:	03c9d793          	srli	a5,s3,0x3c
 68a:	97de                	add	a5,a5,s7
 68c:	0007c583          	lbu	a1,0(a5)
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	e1c080e7          	jalr	-484(ra) # 4ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69a:	0992                	slli	s3,s3,0x4
 69c:	397d                	addiw	s2,s2,-1
 69e:	fe0914e3          	bnez	s2,686 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 6a2:	8be2                	mv	s7,s8
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	6c02                	ld	s8,0(sp)
 6a8:	bf09                	j	5ba <vprintf+0x42>
        s = va_arg(ap, char*);
 6aa:	008b8993          	addi	s3,s7,8
 6ae:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6b2:	02090163          	beqz	s2,6d4 <vprintf+0x15c>
        while(*s != 0){
 6b6:	00094583          	lbu	a1,0(s2)
 6ba:	c9a5                	beqz	a1,72a <vprintf+0x1b2>
          putc(fd, *s);
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	df0080e7          	jalr	-528(ra) # 4ae <putc>
          s++;
 6c6:	0905                	addi	s2,s2,1
        while(*s != 0){
 6c8:	00094583          	lbu	a1,0(s2)
 6cc:	f9e5                	bnez	a1,6bc <vprintf+0x144>
        s = va_arg(ap, char*);
 6ce:	8bce                	mv	s7,s3
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b5e5                	j	5ba <vprintf+0x42>
          s = "(null)";
 6d4:	00000917          	auipc	s2,0x0
 6d8:	52490913          	addi	s2,s2,1316 # bf8 <ithread_join+0xc6>
        while(*s != 0){
 6dc:	02800593          	li	a1,40
 6e0:	bff1                	j	6bc <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 6e2:	008b8913          	addi	s2,s7,8
 6e6:	000bc583          	lbu	a1,0(s7)
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	dc2080e7          	jalr	-574(ra) # 4ae <putc>
 6f4:	8bca                	mv	s7,s2
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b5c9                	j	5ba <vprintf+0x42>
        putc(fd, c);
 6fa:	02500593          	li	a1,37
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	dae080e7          	jalr	-594(ra) # 4ae <putc>
      state = 0;
 708:	4981                	li	s3,0
 70a:	bd45                	j	5ba <vprintf+0x42>
        putc(fd, '%');
 70c:	02500593          	li	a1,37
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	d9c080e7          	jalr	-612(ra) # 4ae <putc>
        putc(fd, c);
 71a:	85ca                	mv	a1,s2
 71c:	8556                	mv	a0,s5
 71e:	00000097          	auipc	ra,0x0
 722:	d90080e7          	jalr	-624(ra) # 4ae <putc>
      state = 0;
 726:	4981                	li	s3,0
 728:	bd49                	j	5ba <vprintf+0x42>
        s = va_arg(ap, char*);
 72a:	8bce                	mv	s7,s3
      state = 0;
 72c:	4981                	li	s3,0
 72e:	b571                	j	5ba <vprintf+0x42>
 730:	74e2                	ld	s1,56(sp)
 732:	79a2                	ld	s3,40(sp)
 734:	7a02                	ld	s4,32(sp)
 736:	6ae2                	ld	s5,24(sp)
 738:	6b42                	ld	s6,16(sp)
 73a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 73c:	60a6                	ld	ra,72(sp)
 73e:	6406                	ld	s0,64(sp)
 740:	7942                	ld	s2,48(sp)
 742:	6161                	addi	sp,sp,80
 744:	8082                	ret

0000000000000746 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 746:	715d                	addi	sp,sp,-80
 748:	ec06                	sd	ra,24(sp)
 74a:	e822                	sd	s0,16(sp)
 74c:	1000                	addi	s0,sp,32
 74e:	e010                	sd	a2,0(s0)
 750:	e414                	sd	a3,8(s0)
 752:	e818                	sd	a4,16(s0)
 754:	ec1c                	sd	a5,24(s0)
 756:	03043023          	sd	a6,32(s0)
 75a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75e:	8622                	mv	a2,s0
 760:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 764:	00000097          	auipc	ra,0x0
 768:	e14080e7          	jalr	-492(ra) # 578 <vprintf>
}
 76c:	60e2                	ld	ra,24(sp)
 76e:	6442                	ld	s0,16(sp)
 770:	6161                	addi	sp,sp,80
 772:	8082                	ret

0000000000000774 <printf>:

void
printf(const char *fmt, ...)
{
 774:	711d                	addi	sp,sp,-96
 776:	ec06                	sd	ra,24(sp)
 778:	e822                	sd	s0,16(sp)
 77a:	1000                	addi	s0,sp,32
 77c:	e40c                	sd	a1,8(s0)
 77e:	e810                	sd	a2,16(s0)
 780:	ec14                	sd	a3,24(s0)
 782:	f018                	sd	a4,32(s0)
 784:	f41c                	sd	a5,40(s0)
 786:	03043823          	sd	a6,48(s0)
 78a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78e:	00840613          	addi	a2,s0,8
 792:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 796:	85aa                	mv	a1,a0
 798:	4505                	li	a0,1
 79a:	00000097          	auipc	ra,0x0
 79e:	dde080e7          	jalr	-546(ra) # 578 <vprintf>
}
 7a2:	60e2                	ld	ra,24(sp)
 7a4:	6442                	ld	s0,16(sp)
 7a6:	6125                	addi	sp,sp,96
 7a8:	8082                	ret

00000000000007aa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7aa:	1141                	addi	sp,sp,-16
 7ac:	e406                	sd	ra,8(sp)
 7ae:	e022                	sd	s0,0(sp)
 7b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b6:	00001797          	auipc	a5,0x1
 7ba:	d6a7b783          	ld	a5,-662(a5) # 1520 <freep>
 7be:	a039                	j	7cc <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c0:	6398                	ld	a4,0(a5)
 7c2:	00e7e463          	bltu	a5,a4,7ca <free+0x20>
 7c6:	00e6ea63          	bltu	a3,a4,7da <free+0x30>
{
 7ca:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7cc:	fed7fae3          	bgeu	a5,a3,7c0 <free+0x16>
 7d0:	6398                	ld	a4,0(a5)
 7d2:	00e6e463          	bltu	a3,a4,7da <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d6:	fee7eae3          	bltu	a5,a4,7ca <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7da:	ff852583          	lw	a1,-8(a0)
 7de:	6390                	ld	a2,0(a5)
 7e0:	02059813          	slli	a6,a1,0x20
 7e4:	01c85713          	srli	a4,a6,0x1c
 7e8:	9736                	add	a4,a4,a3
 7ea:	02e60563          	beq	a2,a4,814 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7ee:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7f2:	4790                	lw	a2,8(a5)
 7f4:	02061593          	slli	a1,a2,0x20
 7f8:	01c5d713          	srli	a4,a1,0x1c
 7fc:	973e                	add	a4,a4,a5
 7fe:	02e68263          	beq	a3,a4,822 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 802:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 804:	00001717          	auipc	a4,0x1
 808:	d0f73e23          	sd	a5,-740(a4) # 1520 <freep>
}
 80c:	60a2                	ld	ra,8(sp)
 80e:	6402                	ld	s0,0(sp)
 810:	0141                	addi	sp,sp,16
 812:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 814:	4618                	lw	a4,8(a2)
 816:	9f2d                	addw	a4,a4,a1
 818:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 81c:	6398                	ld	a4,0(a5)
 81e:	6310                	ld	a2,0(a4)
 820:	b7f9                	j	7ee <free+0x44>
    p->s.size += bp->s.size;
 822:	ff852703          	lw	a4,-8(a0)
 826:	9f31                	addw	a4,a4,a2
 828:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 82a:	ff053683          	ld	a3,-16(a0)
 82e:	bfd1                	j	802 <free+0x58>

0000000000000830 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 830:	7139                	addi	sp,sp,-64
 832:	fc06                	sd	ra,56(sp)
 834:	f822                	sd	s0,48(sp)
 836:	f04a                	sd	s2,32(sp)
 838:	ec4e                	sd	s3,24(sp)
 83a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83c:	02051993          	slli	s3,a0,0x20
 840:	0209d993          	srli	s3,s3,0x20
 844:	09bd                	addi	s3,s3,15
 846:	0049d993          	srli	s3,s3,0x4
 84a:	2985                	addiw	s3,s3,1
 84c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 84e:	00001517          	auipc	a0,0x1
 852:	cd253503          	ld	a0,-814(a0) # 1520 <freep>
 856:	c905                	beqz	a0,886 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85a:	4798                	lw	a4,8(a5)
 85c:	09377a63          	bgeu	a4,s3,8f0 <malloc+0xc0>
 860:	f426                	sd	s1,40(sp)
 862:	e852                	sd	s4,16(sp)
 864:	e456                	sd	s5,8(sp)
 866:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 868:	8a4e                	mv	s4,s3
 86a:	6705                	lui	a4,0x1
 86c:	00e9f363          	bgeu	s3,a4,872 <malloc+0x42>
 870:	6a05                	lui	s4,0x1
 872:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 876:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 87a:	00001497          	auipc	s1,0x1
 87e:	ca648493          	addi	s1,s1,-858 # 1520 <freep>
  if(p == (char*)-1)
 882:	5afd                	li	s5,-1
 884:	a089                	j	8c6 <malloc+0x96>
 886:	f426                	sd	s1,40(sp)
 888:	e852                	sd	s4,16(sp)
 88a:	e456                	sd	s5,8(sp)
 88c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 88e:	00001797          	auipc	a5,0x1
 892:	cb278793          	addi	a5,a5,-846 # 1540 <base>
 896:	00001717          	auipc	a4,0x1
 89a:	c8f73523          	sd	a5,-886(a4) # 1520 <freep>
 89e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a4:	b7d1                	j	868 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8a6:	6398                	ld	a4,0(a5)
 8a8:	e118                	sd	a4,0(a0)
 8aa:	a8b9                	j	908 <malloc+0xd8>
  hp->s.size = nu;
 8ac:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b0:	0541                	addi	a0,a0,16
 8b2:	00000097          	auipc	ra,0x0
 8b6:	ef8080e7          	jalr	-264(ra) # 7aa <free>
  return freep;
 8ba:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8bc:	c135                	beqz	a0,920 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c0:	4798                	lw	a4,8(a5)
 8c2:	03277363          	bgeu	a4,s2,8e8 <malloc+0xb8>
    if(p == freep)
 8c6:	6098                	ld	a4,0(s1)
 8c8:	853e                	mv	a0,a5
 8ca:	fef71ae3          	bne	a4,a5,8be <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8ce:	8552                	mv	a0,s4
 8d0:	00000097          	auipc	ra,0x0
 8d4:	b58080e7          	jalr	-1192(ra) # 428 <sbrk>
  if(p == (char*)-1)
 8d8:	fd551ae3          	bne	a0,s5,8ac <malloc+0x7c>
        return 0;
 8dc:	4501                	li	a0,0
 8de:	74a2                	ld	s1,40(sp)
 8e0:	6a42                	ld	s4,16(sp)
 8e2:	6aa2                	ld	s5,8(sp)
 8e4:	6b02                	ld	s6,0(sp)
 8e6:	a03d                	j	914 <malloc+0xe4>
 8e8:	74a2                	ld	s1,40(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8f0:	fae90be3          	beq	s2,a4,8a6 <malloc+0x76>
        p->s.size -= nunits;
 8f4:	4137073b          	subw	a4,a4,s3
 8f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8fa:	02071693          	slli	a3,a4,0x20
 8fe:	01c6d713          	srli	a4,a3,0x1c
 902:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 904:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 908:	00001717          	auipc	a4,0x1
 90c:	c0a73c23          	sd	a0,-1000(a4) # 1520 <freep>
      return (void*)(p + 1);
 910:	01078513          	addi	a0,a5,16
  }
}
 914:	70e2                	ld	ra,56(sp)
 916:	7442                	ld	s0,48(sp)
 918:	7902                	ld	s2,32(sp)
 91a:	69e2                	ld	s3,24(sp)
 91c:	6121                	addi	sp,sp,64
 91e:	8082                	ret
 920:	74a2                	ld	s1,40(sp)
 922:	6a42                	ld	s4,16(sp)
 924:	6aa2                	ld	s5,8(sp)
 926:	6b02                	ld	s6,0(sp)
 928:	b7f5                	j	914 <malloc+0xe4>

000000000000092a <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 92a:	1141                	addi	sp,sp,-16
 92c:	e406                	sd	ra,8(sp)
 92e:	e022                	sd	s0,0(sp)
 930:	0800                	addi	s0,sp,16
  thread_exit(status);
 932:	2501                	sext.w	a0,a0
 934:	00000097          	auipc	ra,0x0
 938:	b24080e7          	jalr	-1244(ra) # 458 <thread_exit>
}
 93c:	60a2                	ld	ra,8(sp)
 93e:	6402                	ld	s0,0(sp)
 940:	0141                	addi	sp,sp,16
 942:	8082                	ret

0000000000000944 <free_stacks>:
int free_stacks() {
 944:	7179                	addi	sp,sp,-48
 946:	f406                	sd	ra,40(sp)
 948:	f022                	sd	s0,32(sp)
 94a:	ec26                	sd	s1,24(sp)
 94c:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 94e:	00001797          	auipc	a5,0x1
 952:	be27a783          	lw	a5,-1054(a5) # 1530 <num_threads>
 956:	04f05063          	blez	a5,996 <free_stacks+0x52>
 95a:	e84a                	sd	s2,16(sp)
 95c:	e44e                	sd	s3,8(sp)
 95e:	4481                	li	s1,0
    free(stacks[i]);
 960:	00001997          	auipc	s3,0x1
 964:	bc898993          	addi	s3,s3,-1080 # 1528 <stacks>
  for (int i = 0; i < num_threads; i++) {
 968:	00001917          	auipc	s2,0x1
 96c:	bc890913          	addi	s2,s2,-1080 # 1530 <num_threads>
    free(stacks[i]);
 970:	0009b783          	ld	a5,0(s3)
 974:	00349713          	slli	a4,s1,0x3
 978:	97ba                	add	a5,a5,a4
 97a:	6388                	ld	a0,0(a5)
 97c:	00000097          	auipc	ra,0x0
 980:	e2e080e7          	jalr	-466(ra) # 7aa <free>
  for (int i = 0; i < num_threads; i++) {
 984:	0485                	addi	s1,s1,1
 986:	00092703          	lw	a4,0(s2)
 98a:	0004879b          	sext.w	a5,s1
 98e:	fee7c1e3          	blt	a5,a4,970 <free_stacks+0x2c>
 992:	6942                	ld	s2,16(sp)
 994:	69a2                	ld	s3,8(sp)
  free(stacks);
 996:	00001497          	auipc	s1,0x1
 99a:	b9248493          	addi	s1,s1,-1134 # 1528 <stacks>
 99e:	6088                	ld	a0,0(s1)
 9a0:	00000097          	auipc	ra,0x0
 9a4:	e0a080e7          	jalr	-502(ra) # 7aa <free>
  stacks = 0;
 9a8:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 9ac:	00001797          	auipc	a5,0x1
 9b0:	b807a223          	sw	zero,-1148(a5) # 1530 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 9b4:	47a1                	li	a5,8
 9b6:	00001717          	auipc	a4,0x1
 9ba:	b4f72523          	sw	a5,-1206(a4) # 1500 <max_stacks>
  threads_done = 0;
 9be:	00001797          	auipc	a5,0x1
 9c2:	b607ab23          	sw	zero,-1162(a5) # 1534 <threads_done>
}
 9c6:	4501                	li	a0,0
 9c8:	70a2                	ld	ra,40(sp)
 9ca:	7402                	ld	s0,32(sp)
 9cc:	64e2                	ld	s1,24(sp)
 9ce:	6145                	addi	sp,sp,48
 9d0:	8082                	ret

00000000000009d2 <expand_num_threads>:
int expand_num_threads() {
 9d2:	1101                	addi	sp,sp,-32
 9d4:	ec06                	sd	ra,24(sp)
 9d6:	e822                	sd	s0,16(sp)
 9d8:	e426                	sd	s1,8(sp)
 9da:	e04a                	sd	s2,0(sp)
 9dc:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 9de:	00001797          	auipc	a5,0x1
 9e2:	b2278793          	addi	a5,a5,-1246 # 1500 <max_stacks>
 9e6:	4388                	lw	a0,0(a5)
 9e8:	0015151b          	slliw	a0,a0,0x1
 9ec:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 9ee:	0035151b          	slliw	a0,a0,0x3
 9f2:	00000097          	auipc	ra,0x0
 9f6:	e3e080e7          	jalr	-450(ra) # 830 <malloc>
 9fa:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 9fc:	00001617          	auipc	a2,0x1
 a00:	b3462603          	lw	a2,-1228(a2) # 1530 <num_threads>
 a04:	00001497          	auipc	s1,0x1
 a08:	b2448493          	addi	s1,s1,-1244 # 1528 <stacks>
 a0c:	0036161b          	slliw	a2,a2,0x3
 a10:	608c                	ld	a1,0(s1)
 a12:	00000097          	auipc	ra,0x0
 a16:	8d8080e7          	jalr	-1832(ra) # 2ea <memmove>
  free(stacks);
 a1a:	6088                	ld	a0,0(s1)
 a1c:	00000097          	auipc	ra,0x0
 a20:	d8e080e7          	jalr	-626(ra) # 7aa <free>
  stacks = new_stacks;
 a24:	0124b023          	sd	s2,0(s1)
}
 a28:	4501                	li	a0,0
 a2a:	60e2                	ld	ra,24(sp)
 a2c:	6442                	ld	s0,16(sp)
 a2e:	64a2                	ld	s1,8(sp)
 a30:	6902                	ld	s2,0(sp)
 a32:	6105                	addi	sp,sp,32
 a34:	8082                	ret

0000000000000a36 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a36:	7179                	addi	sp,sp,-48
 a38:	f406                	sd	ra,40(sp)
 a3a:	f022                	sd	s0,32(sp)
 a3c:	e84a                	sd	s2,16(sp)
 a3e:	e44e                	sd	s3,8(sp)
 a40:	1800                	addi	s0,sp,48
 a42:	892a                	mv	s2,a0
 a44:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a46:	00001797          	auipc	a5,0x1
 a4a:	ae27b783          	ld	a5,-1310(a5) # 1528 <stacks>
 a4e:	c3d9                	beqz	a5,ad4 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a50:	00001797          	auipc	a5,0x1
 a54:	ab07a783          	lw	a5,-1360(a5) # 1500 <max_stacks>
 a58:	00001717          	auipc	a4,0x1
 a5c:	ad872703          	lw	a4,-1320(a4) # 1530 <num_threads>
 a60:	0af71463          	bne	a4,a5,b08 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 a64:	04000713          	li	a4,64
 a68:	08e78563          	beq	a5,a4,af2 <ithread_create+0xbc>
 a6c:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a6e:	00000097          	auipc	ra,0x0
 a72:	f64080e7          	jalr	-156(ra) # 9d2 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a76:	6505                	lui	a0,0x1
 a78:	00000097          	auipc	ra,0x0
 a7c:	db8080e7          	jalr	-584(ra) # 830 <malloc>
 a80:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a82:	00001717          	auipc	a4,0x1
 a86:	aae72703          	lw	a4,-1362(a4) # 1530 <num_threads>
 a8a:	070e                	slli	a4,a4,0x3
 a8c:	00001797          	auipc	a5,0x1
 a90:	a9c7b783          	ld	a5,-1380(a5) # 1528 <stacks>
 a94:	97ba                	add	a5,a5,a4
 a96:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a98:	00000697          	auipc	a3,0x0
 a9c:	e9268693          	addi	a3,a3,-366 # 92a <ithread_exit>
 aa0:	862a                	mv	a2,a0
 aa2:	85ce                	mv	a1,s3
 aa4:	854a                	mv	a0,s2
 aa6:	00000097          	auipc	ra,0x0
 aaa:	9a2080e7          	jalr	-1630(ra) # 448 <create_thread>
 aae:	892a                	mv	s2,a0
  if (res != -1) {
 ab0:	57fd                	li	a5,-1
 ab2:	04f50d63          	beq	a0,a5,b0c <ithread_create+0xd6>
    num_threads++;
 ab6:	00001717          	auipc	a4,0x1
 aba:	a7a70713          	addi	a4,a4,-1414 # 1530 <num_threads>
 abe:	431c                	lw	a5,0(a4)
 ac0:	2785                	addiw	a5,a5,1
 ac2:	c31c                	sw	a5,0(a4)
 ac4:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 ac6:	854a                	mv	a0,s2
 ac8:	70a2                	ld	ra,40(sp)
 aca:	7402                	ld	s0,32(sp)
 acc:	6942                	ld	s2,16(sp)
 ace:	69a2                	ld	s3,8(sp)
 ad0:	6145                	addi	sp,sp,48
 ad2:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 ad4:	00001517          	auipc	a0,0x1
 ad8:	a2c52503          	lw	a0,-1492(a0) # 1500 <max_stacks>
 adc:	0035151b          	slliw	a0,a0,0x3
 ae0:	00000097          	auipc	ra,0x0
 ae4:	d50080e7          	jalr	-688(ra) # 830 <malloc>
 ae8:	00001797          	auipc	a5,0x1
 aec:	a4a7b023          	sd	a0,-1472(a5) # 1528 <stacks>
 af0:	b785                	j	a50 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 af2:	00000517          	auipc	a0,0x0
 af6:	10e50513          	addi	a0,a0,270 # c00 <ithread_join+0xce>
 afa:	00000097          	auipc	ra,0x0
 afe:	c7a080e7          	jalr	-902(ra) # 774 <printf>
      return -1;
 b02:	57fd                	li	a5,-1
 b04:	893e                	mv	s2,a5
 b06:	b7c1                	j	ac6 <ithread_create+0x90>
 b08:	ec26                	sd	s1,24(sp)
 b0a:	b7b5                	j	a76 <ithread_create+0x40>
    free(stack_ptr);
 b0c:	8526                	mv	a0,s1
 b0e:	00000097          	auipc	ra,0x0
 b12:	c9c080e7          	jalr	-868(ra) # 7aa <free>
    stacks[num_threads] = 0;
 b16:	00001717          	auipc	a4,0x1
 b1a:	a1a72703          	lw	a4,-1510(a4) # 1530 <num_threads>
 b1e:	070e                	slli	a4,a4,0x3
 b20:	00001797          	auipc	a5,0x1
 b24:	a087b783          	ld	a5,-1528(a5) # 1528 <stacks>
 b28:	97ba                	add	a5,a5,a4
 b2a:	0007b023          	sd	zero,0(a5)
 b2e:	64e2                	ld	s1,24(sp)
 b30:	bf59                	j	ac6 <ithread_create+0x90>

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
 b46:	90e080e7          	jalr	-1778(ra) # 450 <join_thread>
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
 b74:	dd4080e7          	jalr	-556(ra) # 944 <free_stacks>
 b78:	b7f5                	j	b64 <ithread_join+0x32>
