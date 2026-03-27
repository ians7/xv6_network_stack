
src/user/_init:     file format elf64-littleriscv


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
  12:	b5250513          	addi	a0,a0,-1198 # b60 <ithread_join+0x4e>
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
  3a:	b3290913          	addi	s2,s2,-1230 # b68 <ithread_join+0x56>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	714080e7          	jalr	1812(ra) # 754 <printf>
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
  6e:	b4e50513          	addi	a0,a0,-1202 # bb8 <ithread_join+0xa6>
  72:	00000097          	auipc	ra,0x0
  76:	6e2080e7          	jalr	1762(ra) # 754 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	302080e7          	jalr	770(ra) # 37e <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	ad850513          	addi	a0,a0,-1320 # b60 <ithread_join+0x4e>
  90:	00000097          	auipc	ra,0x0
  94:	336080e7          	jalr	822(ra) # 3c6 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	ac650513          	addi	a0,a0,-1338 # b60 <ithread_join+0x4e>
  a2:	00000097          	auipc	ra,0x0
  a6:	31c080e7          	jalr	796(ra) # 3be <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	ad450513          	addi	a0,a0,-1324 # b80 <ithread_join+0x6e>
  b4:	00000097          	auipc	ra,0x0
  b8:	6a0080e7          	jalr	1696(ra) # 754 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2c0080e7          	jalr	704(ra) # 37e <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	f4a58593          	addi	a1,a1,-182 # 1010 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	aca50513          	addi	a0,a0,-1334 # b98 <ithread_join+0x86>
  d6:	00000097          	auipc	ra,0x0
  da:	2e0080e7          	jalr	736(ra) # 3b6 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	ac250513          	addi	a0,a0,-1342 # ba0 <ithread_join+0x8e>
  e6:	00000097          	auipc	ra,0x0
  ea:	66e080e7          	jalr	1646(ra) # 754 <printf>
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
 16a:	86be                	mv	a3,a5
 16c:	0785                	addi	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	ff65                	bnez	a4,16a <strlen+0x10>
 174:	40a6853b          	subw	a0,a3,a0
 178:	2505                	addiw	a0,a0,1
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
    buf[i++] = c;
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
 244:	e04a                	sd	s2,0(sp)
 246:	1000                	addi	s0,sp,32
 248:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24a:	4581                	li	a1,0
 24c:	00000097          	auipc	ra,0x0
 250:	172080e7          	jalr	370(ra) # 3be <open>
  if(fd < 0)
 254:	02054663          	bltz	a0,280 <stat+0x42>
 258:	e426                	sd	s1,8(sp)
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
 272:	64a2                	ld	s1,8(sp)
}
 274:	854a                	mv	a0,s2
 276:	60e2                	ld	ra,24(sp)
 278:	6442                	ld	s0,16(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	addi	sp,sp,32
 27e:	8082                	ret
    return -1;
 280:	597d                	li	s2,-1
 282:	bfcd                	j	274 <stat+0x36>

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
 2f0:	fef71ae3          	bne	a4,a5,2e4 <memmove+0x18>
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

000000000000043e <socket>:
.global socket
socket:
 li a7, SYS_socket
 43e:	48e9                	li	a7,26
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <bind>:
.global bind
bind:
 li a7, SYS_bind
 446:	48ed                	li	a7,27
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <accept>:
.global accept
accept:
 li a7, SYS_accept
 44e:	48f5                	li	a7,29
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <listen>:
.global listen
listen:
 li a7, SYS_listen
 456:	48f1                	li	a7,28
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <connect>:
.global connect
connect:
 li a7, SYS_connect
 45e:	48f9                	li	a7,30
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <send>:
.global send
send:
 li a7, SYS_send
 466:	48fd                	li	a7,31
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <recv>:
.global recv
recv:
 li a7, SYS_recv
 46e:	02000893          	li	a7,32
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 478:	02100893          	li	a7,33
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 482:	02200893          	li	a7,34
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 48c:	1101                	addi	sp,sp,-32
 48e:	ec06                	sd	ra,24(sp)
 490:	e822                	sd	s0,16(sp)
 492:	1000                	addi	s0,sp,32
 494:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 498:	4605                	li	a2,1
 49a:	fef40593          	addi	a1,s0,-17
 49e:	00000097          	auipc	ra,0x0
 4a2:	f00080e7          	jalr	-256(ra) # 39e <write>
}
 4a6:	60e2                	ld	ra,24(sp)
 4a8:	6442                	ld	s0,16(sp)
 4aa:	6105                	addi	sp,sp,32
 4ac:	8082                	ret

00000000000004ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ae:	7139                	addi	sp,sp,-64
 4b0:	fc06                	sd	ra,56(sp)
 4b2:	f822                	sd	s0,48(sp)
 4b4:	f426                	sd	s1,40(sp)
 4b6:	0080                	addi	s0,sp,64
 4b8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ba:	c299                	beqz	a3,4c0 <printint+0x12>
 4bc:	0805cb63          	bltz	a1,552 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4c0:	2581                	sext.w	a1,a1
  neg = 0;
 4c2:	4881                	li	a7,0
 4c4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4c8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ca:	2601                	sext.w	a2,a2
 4cc:	00000517          	auipc	a0,0x0
 4d0:	79c50513          	addi	a0,a0,1948 # c68 <digits>
 4d4:	883a                	mv	a6,a4
 4d6:	2705                	addiw	a4,a4,1
 4d8:	02c5f7bb          	remuw	a5,a1,a2
 4dc:	1782                	slli	a5,a5,0x20
 4de:	9381                	srli	a5,a5,0x20
 4e0:	97aa                	add	a5,a5,a0
 4e2:	0007c783          	lbu	a5,0(a5)
 4e6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ea:	0005879b          	sext.w	a5,a1
 4ee:	02c5d5bb          	divuw	a1,a1,a2
 4f2:	0685                	addi	a3,a3,1
 4f4:	fec7f0e3          	bgeu	a5,a2,4d4 <printint+0x26>
  if(neg)
 4f8:	00088c63          	beqz	a7,510 <printint+0x62>
    buf[i++] = '-';
 4fc:	fd070793          	addi	a5,a4,-48
 500:	00878733          	add	a4,a5,s0
 504:	02d00793          	li	a5,45
 508:	fef70823          	sb	a5,-16(a4)
 50c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 510:	02e05c63          	blez	a4,548 <printint+0x9a>
 514:	f04a                	sd	s2,32(sp)
 516:	ec4e                	sd	s3,24(sp)
 518:	fc040793          	addi	a5,s0,-64
 51c:	00e78933          	add	s2,a5,a4
 520:	fff78993          	addi	s3,a5,-1
 524:	99ba                	add	s3,s3,a4
 526:	377d                	addiw	a4,a4,-1
 528:	1702                	slli	a4,a4,0x20
 52a:	9301                	srli	a4,a4,0x20
 52c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 530:	fff94583          	lbu	a1,-1(s2)
 534:	8526                	mv	a0,s1
 536:	00000097          	auipc	ra,0x0
 53a:	f56080e7          	jalr	-170(ra) # 48c <putc>
  while(--i >= 0)
 53e:	197d                	addi	s2,s2,-1
 540:	ff3918e3          	bne	s2,s3,530 <printint+0x82>
 544:	7902                	ld	s2,32(sp)
 546:	69e2                	ld	s3,24(sp)
}
 548:	70e2                	ld	ra,56(sp)
 54a:	7442                	ld	s0,48(sp)
 54c:	74a2                	ld	s1,40(sp)
 54e:	6121                	addi	sp,sp,64
 550:	8082                	ret
    x = -xx;
 552:	40b005bb          	negw	a1,a1
    neg = 1;
 556:	4885                	li	a7,1
    x = -xx;
 558:	b7b5                	j	4c4 <printint+0x16>

000000000000055a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 55a:	715d                	addi	sp,sp,-80
 55c:	e486                	sd	ra,72(sp)
 55e:	e0a2                	sd	s0,64(sp)
 560:	f84a                	sd	s2,48(sp)
 562:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 564:	0005c903          	lbu	s2,0(a1)
 568:	1a090a63          	beqz	s2,71c <vprintf+0x1c2>
 56c:	fc26                	sd	s1,56(sp)
 56e:	f44e                	sd	s3,40(sp)
 570:	f052                	sd	s4,32(sp)
 572:	ec56                	sd	s5,24(sp)
 574:	e85a                	sd	s6,16(sp)
 576:	e45e                	sd	s7,8(sp)
 578:	8aaa                	mv	s5,a0
 57a:	8bb2                	mv	s7,a2
 57c:	00158493          	addi	s1,a1,1
  state = 0;
 580:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 582:	02500a13          	li	s4,37
 586:	4b55                	li	s6,21
 588:	a839                	j	5a6 <vprintf+0x4c>
        putc(fd, c);
 58a:	85ca                	mv	a1,s2
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	efe080e7          	jalr	-258(ra) # 48c <putc>
 596:	a019                	j	59c <vprintf+0x42>
    } else if(state == '%'){
 598:	01498d63          	beq	s3,s4,5b2 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 59c:	0485                	addi	s1,s1,1
 59e:	fff4c903          	lbu	s2,-1(s1)
 5a2:	16090763          	beqz	s2,710 <vprintf+0x1b6>
    if(state == 0){
 5a6:	fe0999e3          	bnez	s3,598 <vprintf+0x3e>
      if(c == '%'){
 5aa:	ff4910e3          	bne	s2,s4,58a <vprintf+0x30>
        state = '%';
 5ae:	89d2                	mv	s3,s4
 5b0:	b7f5                	j	59c <vprintf+0x42>
      if(c == 'd'){
 5b2:	13490463          	beq	s2,s4,6da <vprintf+0x180>
 5b6:	f9d9079b          	addiw	a5,s2,-99
 5ba:	0ff7f793          	zext.b	a5,a5
 5be:	12fb6763          	bltu	s6,a5,6ec <vprintf+0x192>
 5c2:	f9d9079b          	addiw	a5,s2,-99
 5c6:	0ff7f713          	zext.b	a4,a5
 5ca:	12eb6163          	bltu	s6,a4,6ec <vprintf+0x192>
 5ce:	00271793          	slli	a5,a4,0x2
 5d2:	00000717          	auipc	a4,0x0
 5d6:	63e70713          	addi	a4,a4,1598 # c10 <ithread_join+0xfe>
 5da:	97ba                	add	a5,a5,a4
 5dc:	439c                	lw	a5,0(a5)
 5de:	97ba                	add	a5,a5,a4
 5e0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5e2:	008b8913          	addi	s2,s7,8
 5e6:	4685                	li	a3,1
 5e8:	4629                	li	a2,10
 5ea:	000ba583          	lw	a1,0(s7)
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	ebe080e7          	jalr	-322(ra) # 4ae <printint>
 5f8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b745                	j	59c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fe:	008b8913          	addi	s2,s7,8
 602:	4681                	li	a3,0
 604:	4629                	li	a2,10
 606:	000ba583          	lw	a1,0(s7)
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	ea2080e7          	jalr	-350(ra) # 4ae <printint>
 614:	8bca                	mv	s7,s2
      state = 0;
 616:	4981                	li	s3,0
 618:	b751                	j	59c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 61a:	008b8913          	addi	s2,s7,8
 61e:	4681                	li	a3,0
 620:	4641                	li	a2,16
 622:	000ba583          	lw	a1,0(s7)
 626:	8556                	mv	a0,s5
 628:	00000097          	auipc	ra,0x0
 62c:	e86080e7          	jalr	-378(ra) # 4ae <printint>
 630:	8bca                	mv	s7,s2
      state = 0;
 632:	4981                	li	s3,0
 634:	b7a5                	j	59c <vprintf+0x42>
 636:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 638:	008b8c13          	addi	s8,s7,8
 63c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 640:	03000593          	li	a1,48
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e46080e7          	jalr	-442(ra) # 48c <putc>
  putc(fd, 'x');
 64e:	07800593          	li	a1,120
 652:	8556                	mv	a0,s5
 654:	00000097          	auipc	ra,0x0
 658:	e38080e7          	jalr	-456(ra) # 48c <putc>
 65c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65e:	00000b97          	auipc	s7,0x0
 662:	60ab8b93          	addi	s7,s7,1546 # c68 <digits>
 666:	03c9d793          	srli	a5,s3,0x3c
 66a:	97de                	add	a5,a5,s7
 66c:	0007c583          	lbu	a1,0(a5)
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	e1a080e7          	jalr	-486(ra) # 48c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 67a:	0992                	slli	s3,s3,0x4
 67c:	397d                	addiw	s2,s2,-1
 67e:	fe0914e3          	bnez	s2,666 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 682:	8be2                	mv	s7,s8
      state = 0;
 684:	4981                	li	s3,0
 686:	6c02                	ld	s8,0(sp)
 688:	bf11                	j	59c <vprintf+0x42>
        s = va_arg(ap, char*);
 68a:	008b8993          	addi	s3,s7,8
 68e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 692:	02090163          	beqz	s2,6b4 <vprintf+0x15a>
        while(*s != 0){
 696:	00094583          	lbu	a1,0(s2)
 69a:	c9a5                	beqz	a1,70a <vprintf+0x1b0>
          putc(fd, *s);
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	dee080e7          	jalr	-530(ra) # 48c <putc>
          s++;
 6a6:	0905                	addi	s2,s2,1
        while(*s != 0){
 6a8:	00094583          	lbu	a1,0(s2)
 6ac:	f9e5                	bnez	a1,69c <vprintf+0x142>
        s = va_arg(ap, char*);
 6ae:	8bce                	mv	s7,s3
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b5ed                	j	59c <vprintf+0x42>
          s = "(null)";
 6b4:	00000917          	auipc	s2,0x0
 6b8:	52490913          	addi	s2,s2,1316 # bd8 <ithread_join+0xc6>
        while(*s != 0){
 6bc:	02800593          	li	a1,40
 6c0:	bff1                	j	69c <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6c2:	008b8913          	addi	s2,s7,8
 6c6:	000bc583          	lbu	a1,0(s7)
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	dc0080e7          	jalr	-576(ra) # 48c <putc>
 6d4:	8bca                	mv	s7,s2
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	b5d1                	j	59c <vprintf+0x42>
        putc(fd, c);
 6da:	02500593          	li	a1,37
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	dac080e7          	jalr	-596(ra) # 48c <putc>
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bd4d                	j	59c <vprintf+0x42>
        putc(fd, '%');
 6ec:	02500593          	li	a1,37
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	d9a080e7          	jalr	-614(ra) # 48c <putc>
        putc(fd, c);
 6fa:	85ca                	mv	a1,s2
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	d8e080e7          	jalr	-626(ra) # 48c <putc>
      state = 0;
 706:	4981                	li	s3,0
 708:	bd51                	j	59c <vprintf+0x42>
        s = va_arg(ap, char*);
 70a:	8bce                	mv	s7,s3
      state = 0;
 70c:	4981                	li	s3,0
 70e:	b579                	j	59c <vprintf+0x42>
 710:	74e2                	ld	s1,56(sp)
 712:	79a2                	ld	s3,40(sp)
 714:	7a02                	ld	s4,32(sp)
 716:	6ae2                	ld	s5,24(sp)
 718:	6b42                	ld	s6,16(sp)
 71a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 71c:	60a6                	ld	ra,72(sp)
 71e:	6406                	ld	s0,64(sp)
 720:	7942                	ld	s2,48(sp)
 722:	6161                	addi	sp,sp,80
 724:	8082                	ret

0000000000000726 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 726:	715d                	addi	sp,sp,-80
 728:	ec06                	sd	ra,24(sp)
 72a:	e822                	sd	s0,16(sp)
 72c:	1000                	addi	s0,sp,32
 72e:	e010                	sd	a2,0(s0)
 730:	e414                	sd	a3,8(s0)
 732:	e818                	sd	a4,16(s0)
 734:	ec1c                	sd	a5,24(s0)
 736:	03043023          	sd	a6,32(s0)
 73a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 73e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 742:	8622                	mv	a2,s0
 744:	00000097          	auipc	ra,0x0
 748:	e16080e7          	jalr	-490(ra) # 55a <vprintf>
}
 74c:	60e2                	ld	ra,24(sp)
 74e:	6442                	ld	s0,16(sp)
 750:	6161                	addi	sp,sp,80
 752:	8082                	ret

0000000000000754 <printf>:

void
printf(const char *fmt, ...)
{
 754:	711d                	addi	sp,sp,-96
 756:	ec06                	sd	ra,24(sp)
 758:	e822                	sd	s0,16(sp)
 75a:	1000                	addi	s0,sp,32
 75c:	e40c                	sd	a1,8(s0)
 75e:	e810                	sd	a2,16(s0)
 760:	ec14                	sd	a3,24(s0)
 762:	f018                	sd	a4,32(s0)
 764:	f41c                	sd	a5,40(s0)
 766:	03043823          	sd	a6,48(s0)
 76a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76e:	00840613          	addi	a2,s0,8
 772:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 776:	85aa                	mv	a1,a0
 778:	4505                	li	a0,1
 77a:	00000097          	auipc	ra,0x0
 77e:	de0080e7          	jalr	-544(ra) # 55a <vprintf>
}
 782:	60e2                	ld	ra,24(sp)
 784:	6442                	ld	s0,16(sp)
 786:	6125                	addi	sp,sp,96
 788:	8082                	ret

000000000000078a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 78a:	1141                	addi	sp,sp,-16
 78c:	e422                	sd	s0,8(sp)
 78e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 790:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 794:	00001797          	auipc	a5,0x1
 798:	88c7b783          	ld	a5,-1908(a5) # 1020 <freep>
 79c:	a02d                	j	7c6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 79e:	4618                	lw	a4,8(a2)
 7a0:	9f2d                	addw	a4,a4,a1
 7a2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a6:	6398                	ld	a4,0(a5)
 7a8:	6310                	ld	a2,0(a4)
 7aa:	a83d                	j	7e8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ac:	ff852703          	lw	a4,-8(a0)
 7b0:	9f31                	addw	a4,a4,a2
 7b2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7b4:	ff053683          	ld	a3,-16(a0)
 7b8:	a091                	j	7fc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ba:	6398                	ld	a4,0(a5)
 7bc:	00e7e463          	bltu	a5,a4,7c4 <free+0x3a>
 7c0:	00e6ea63          	bltu	a3,a4,7d4 <free+0x4a>
{
 7c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	fed7fae3          	bgeu	a5,a3,7ba <free+0x30>
 7ca:	6398                	ld	a4,0(a5)
 7cc:	00e6e463          	bltu	a3,a4,7d4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	fee7eae3          	bltu	a5,a4,7c4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7d4:	ff852583          	lw	a1,-8(a0)
 7d8:	6390                	ld	a2,0(a5)
 7da:	02059813          	slli	a6,a1,0x20
 7de:	01c85713          	srli	a4,a6,0x1c
 7e2:	9736                	add	a4,a4,a3
 7e4:	fae60de3          	beq	a2,a4,79e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ec:	4790                	lw	a2,8(a5)
 7ee:	02061593          	slli	a1,a2,0x20
 7f2:	01c5d713          	srli	a4,a1,0x1c
 7f6:	973e                	add	a4,a4,a5
 7f8:	fae68ae3          	beq	a3,a4,7ac <free+0x22>
    p->s.ptr = bp->s.ptr;
 7fc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7fe:	00001717          	auipc	a4,0x1
 802:	82f73123          	sd	a5,-2014(a4) # 1020 <freep>
}
 806:	6422                	ld	s0,8(sp)
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
 812:	f426                	sd	s1,40(sp)
 814:	ec4e                	sd	s3,24(sp)
 816:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 818:	02051493          	slli	s1,a0,0x20
 81c:	9081                	srli	s1,s1,0x20
 81e:	04bd                	addi	s1,s1,15
 820:	8091                	srli	s1,s1,0x4
 822:	0014899b          	addiw	s3,s1,1
 826:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 828:	00000517          	auipc	a0,0x0
 82c:	7f853503          	ld	a0,2040(a0) # 1020 <freep>
 830:	c915                	beqz	a0,864 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 832:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 834:	4798                	lw	a4,8(a5)
 836:	08977e63          	bgeu	a4,s1,8d2 <malloc+0xc6>
 83a:	f04a                	sd	s2,32(sp)
 83c:	e852                	sd	s4,16(sp)
 83e:	e456                	sd	s5,8(sp)
 840:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 842:	8a4e                	mv	s4,s3
 844:	0009871b          	sext.w	a4,s3
 848:	6685                	lui	a3,0x1
 84a:	00d77363          	bgeu	a4,a3,850 <malloc+0x44>
 84e:	6a05                	lui	s4,0x1
 850:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 854:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 858:	00000917          	auipc	s2,0x0
 85c:	7c890913          	addi	s2,s2,1992 # 1020 <freep>
  if(p == (char*)-1)
 860:	5afd                	li	s5,-1
 862:	a091                	j	8a6 <malloc+0x9a>
 864:	f04a                	sd	s2,32(sp)
 866:	e852                	sd	s4,16(sp)
 868:	e456                	sd	s5,8(sp)
 86a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 86c:	00000797          	auipc	a5,0x0
 870:	7d478793          	addi	a5,a5,2004 # 1040 <base>
 874:	00000717          	auipc	a4,0x0
 878:	7af73623          	sd	a5,1964(a4) # 1020 <freep>
 87c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 87e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 882:	b7c1                	j	842 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 884:	6398                	ld	a4,0(a5)
 886:	e118                	sd	a4,0(a0)
 888:	a08d                	j	8ea <malloc+0xde>
  hp->s.size = nu;
 88a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88e:	0541                	addi	a0,a0,16
 890:	00000097          	auipc	ra,0x0
 894:	efa080e7          	jalr	-262(ra) # 78a <free>
  return freep;
 898:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 89c:	c13d                	beqz	a0,902 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a0:	4798                	lw	a4,8(a5)
 8a2:	02977463          	bgeu	a4,s1,8ca <malloc+0xbe>
    if(p == freep)
 8a6:	00093703          	ld	a4,0(s2)
 8aa:	853e                	mv	a0,a5
 8ac:	fef719e3          	bne	a4,a5,89e <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 8b0:	8552                	mv	a0,s4
 8b2:	00000097          	auipc	ra,0x0
 8b6:	b54080e7          	jalr	-1196(ra) # 406 <sbrk>
  if(p == (char*)-1)
 8ba:	fd5518e3          	bne	a0,s5,88a <malloc+0x7e>
        return 0;
 8be:	4501                	li	a0,0
 8c0:	7902                	ld	s2,32(sp)
 8c2:	6a42                	ld	s4,16(sp)
 8c4:	6aa2                	ld	s5,8(sp)
 8c6:	6b02                	ld	s6,0(sp)
 8c8:	a03d                	j	8f6 <malloc+0xea>
 8ca:	7902                	ld	s2,32(sp)
 8cc:	6a42                	ld	s4,16(sp)
 8ce:	6aa2                	ld	s5,8(sp)
 8d0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8d2:	fae489e3          	beq	s1,a4,884 <malloc+0x78>
        p->s.size -= nunits;
 8d6:	4137073b          	subw	a4,a4,s3
 8da:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8dc:	02071693          	slli	a3,a4,0x20
 8e0:	01c6d713          	srli	a4,a3,0x1c
 8e4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ea:	00000717          	auipc	a4,0x0
 8ee:	72a73b23          	sd	a0,1846(a4) # 1020 <freep>
      return (void*)(p + 1);
 8f2:	01078513          	addi	a0,a5,16
  }
}
 8f6:	70e2                	ld	ra,56(sp)
 8f8:	7442                	ld	s0,48(sp)
 8fa:	74a2                	ld	s1,40(sp)
 8fc:	69e2                	ld	s3,24(sp)
 8fe:	6121                	addi	sp,sp,64
 900:	8082                	ret
 902:	7902                	ld	s2,32(sp)
 904:	6a42                	ld	s4,16(sp)
 906:	6aa2                	ld	s5,8(sp)
 908:	6b02                	ld	s6,0(sp)
 90a:	b7f5                	j	8f6 <malloc+0xea>

000000000000090c <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 90c:	1141                	addi	sp,sp,-16
 90e:	e406                	sd	ra,8(sp)
 910:	e022                	sd	s0,0(sp)
 912:	0800                	addi	s0,sp,16
  thread_exit(status);
 914:	2501                	sext.w	a0,a0
 916:	00000097          	auipc	ra,0x0
 91a:	b20080e7          	jalr	-1248(ra) # 436 <thread_exit>
}
 91e:	60a2                	ld	ra,8(sp)
 920:	6402                	ld	s0,0(sp)
 922:	0141                	addi	sp,sp,16
 924:	8082                	ret

0000000000000926 <free_stacks>:
int free_stacks() {
 926:	7179                	addi	sp,sp,-48
 928:	f406                	sd	ra,40(sp)
 92a:	f022                	sd	s0,32(sp)
 92c:	ec26                	sd	s1,24(sp)
 92e:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 930:	00000797          	auipc	a5,0x0
 934:	7007a783          	lw	a5,1792(a5) # 1030 <num_threads>
 938:	04f05063          	blez	a5,978 <free_stacks+0x52>
 93c:	e84a                	sd	s2,16(sp)
 93e:	e44e                	sd	s3,8(sp)
 940:	4481                	li	s1,0
    free(stacks[i]);
 942:	00000997          	auipc	s3,0x0
 946:	6e698993          	addi	s3,s3,1766 # 1028 <stacks>
  for (int i = 0; i < num_threads; i++) {
 94a:	00000917          	auipc	s2,0x0
 94e:	6e690913          	addi	s2,s2,1766 # 1030 <num_threads>
    free(stacks[i]);
 952:	0009b783          	ld	a5,0(s3)
 956:	00349713          	slli	a4,s1,0x3
 95a:	97ba                	add	a5,a5,a4
 95c:	6388                	ld	a0,0(a5)
 95e:	00000097          	auipc	ra,0x0
 962:	e2c080e7          	jalr	-468(ra) # 78a <free>
  for (int i = 0; i < num_threads; i++) {
 966:	0485                	addi	s1,s1,1
 968:	00092703          	lw	a4,0(s2)
 96c:	0004879b          	sext.w	a5,s1
 970:	fee7c1e3          	blt	a5,a4,952 <free_stacks+0x2c>
 974:	6942                	ld	s2,16(sp)
 976:	69a2                	ld	s3,8(sp)
  free(stacks);
 978:	00000497          	auipc	s1,0x0
 97c:	6b048493          	addi	s1,s1,1712 # 1028 <stacks>
 980:	6088                	ld	a0,0(s1)
 982:	00000097          	auipc	ra,0x0
 986:	e08080e7          	jalr	-504(ra) # 78a <free>
  stacks = 0;
 98a:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 98e:	00000797          	auipc	a5,0x0
 992:	6a07a123          	sw	zero,1698(a5) # 1030 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 996:	47a1                	li	a5,8
 998:	00000717          	auipc	a4,0x0
 99c:	66f72423          	sw	a5,1640(a4) # 1000 <max_stacks>
  threads_done = 0;
 9a0:	00000797          	auipc	a5,0x0
 9a4:	6807aa23          	sw	zero,1684(a5) # 1034 <threads_done>
}
 9a8:	4501                	li	a0,0
 9aa:	70a2                	ld	ra,40(sp)
 9ac:	7402                	ld	s0,32(sp)
 9ae:	64e2                	ld	s1,24(sp)
 9b0:	6145                	addi	sp,sp,48
 9b2:	8082                	ret

00000000000009b4 <expand_num_threads>:
int expand_num_threads() {
 9b4:	1101                	addi	sp,sp,-32
 9b6:	ec06                	sd	ra,24(sp)
 9b8:	e822                	sd	s0,16(sp)
 9ba:	e426                	sd	s1,8(sp)
 9bc:	e04a                	sd	s2,0(sp)
 9be:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 9c0:	00000797          	auipc	a5,0x0
 9c4:	64078793          	addi	a5,a5,1600 # 1000 <max_stacks>
 9c8:	4388                	lw	a0,0(a5)
 9ca:	0015151b          	slliw	a0,a0,0x1
 9ce:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 9d0:	0035151b          	slliw	a0,a0,0x3
 9d4:	00000097          	auipc	ra,0x0
 9d8:	e38080e7          	jalr	-456(ra) # 80c <malloc>
 9dc:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 9de:	00000617          	auipc	a2,0x0
 9e2:	65262603          	lw	a2,1618(a2) # 1030 <num_threads>
 9e6:	00000497          	auipc	s1,0x0
 9ea:	64248493          	addi	s1,s1,1602 # 1028 <stacks>
 9ee:	0036161b          	slliw	a2,a2,0x3
 9f2:	608c                	ld	a1,0(s1)
 9f4:	00000097          	auipc	ra,0x0
 9f8:	8d8080e7          	jalr	-1832(ra) # 2cc <memmove>
  free(stacks);
 9fc:	6088                	ld	a0,0(s1)
 9fe:	00000097          	auipc	ra,0x0
 a02:	d8c080e7          	jalr	-628(ra) # 78a <free>
  stacks = new_stacks;
 a06:	0124b023          	sd	s2,0(s1)
}
 a0a:	4501                	li	a0,0
 a0c:	60e2                	ld	ra,24(sp)
 a0e:	6442                	ld	s0,16(sp)
 a10:	64a2                	ld	s1,8(sp)
 a12:	6902                	ld	s2,0(sp)
 a14:	6105                	addi	sp,sp,32
 a16:	8082                	ret

0000000000000a18 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a18:	7179                	addi	sp,sp,-48
 a1a:	f406                	sd	ra,40(sp)
 a1c:	f022                	sd	s0,32(sp)
 a1e:	e84a                	sd	s2,16(sp)
 a20:	e44e                	sd	s3,8(sp)
 a22:	1800                	addi	s0,sp,48
 a24:	892a                	mv	s2,a0
 a26:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a28:	00000797          	auipc	a5,0x0
 a2c:	6007b783          	ld	a5,1536(a5) # 1028 <stacks>
 a30:	c3d9                	beqz	a5,ab6 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a32:	00000797          	auipc	a5,0x0
 a36:	5ce7a783          	lw	a5,1486(a5) # 1000 <max_stacks>
 a3a:	00000717          	auipc	a4,0x0
 a3e:	5f672703          	lw	a4,1526(a4) # 1030 <num_threads>
 a42:	0af71363          	bne	a4,a5,ae8 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 a46:	04000713          	li	a4,64
 a4a:	08e78563          	beq	a5,a4,ad4 <ithread_create+0xbc>
 a4e:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a50:	00000097          	auipc	ra,0x0
 a54:	f64080e7          	jalr	-156(ra) # 9b4 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a58:	6505                	lui	a0,0x1
 a5a:	00000097          	auipc	ra,0x0
 a5e:	db2080e7          	jalr	-590(ra) # 80c <malloc>
 a62:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a64:	00000717          	auipc	a4,0x0
 a68:	5cc72703          	lw	a4,1484(a4) # 1030 <num_threads>
 a6c:	070e                	slli	a4,a4,0x3
 a6e:	00000797          	auipc	a5,0x0
 a72:	5ba7b783          	ld	a5,1466(a5) # 1028 <stacks>
 a76:	97ba                	add	a5,a5,a4
 a78:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a7a:	00000697          	auipc	a3,0x0
 a7e:	e9268693          	addi	a3,a3,-366 # 90c <ithread_exit>
 a82:	862a                	mv	a2,a0
 a84:	85ce                	mv	a1,s3
 a86:	854a                	mv	a0,s2
 a88:	00000097          	auipc	ra,0x0
 a8c:	99e080e7          	jalr	-1634(ra) # 426 <create_thread>
 a90:	892a                	mv	s2,a0
  if (res != -1) {
 a92:	57fd                	li	a5,-1
 a94:	04f50c63          	beq	a0,a5,aec <ithread_create+0xd4>
    num_threads++;
 a98:	00000717          	auipc	a4,0x0
 a9c:	59870713          	addi	a4,a4,1432 # 1030 <num_threads>
 aa0:	431c                	lw	a5,0(a4)
 aa2:	2785                	addiw	a5,a5,1
 aa4:	c31c                	sw	a5,0(a4)
 aa6:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 aa8:	854a                	mv	a0,s2
 aaa:	70a2                	ld	ra,40(sp)
 aac:	7402                	ld	s0,32(sp)
 aae:	6942                	ld	s2,16(sp)
 ab0:	69a2                	ld	s3,8(sp)
 ab2:	6145                	addi	sp,sp,48
 ab4:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 ab6:	00000517          	auipc	a0,0x0
 aba:	54a52503          	lw	a0,1354(a0) # 1000 <max_stacks>
 abe:	0035151b          	slliw	a0,a0,0x3
 ac2:	00000097          	auipc	ra,0x0
 ac6:	d4a080e7          	jalr	-694(ra) # 80c <malloc>
 aca:	00000797          	auipc	a5,0x0
 ace:	54a7bf23          	sd	a0,1374(a5) # 1028 <stacks>
 ad2:	b785                	j	a32 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 ad4:	00000517          	auipc	a0,0x0
 ad8:	10c50513          	addi	a0,a0,268 # be0 <ithread_join+0xce>
 adc:	00000097          	auipc	ra,0x0
 ae0:	c78080e7          	jalr	-904(ra) # 754 <printf>
      return -1;
 ae4:	597d                	li	s2,-1
 ae6:	b7c9                	j	aa8 <ithread_create+0x90>
 ae8:	ec26                	sd	s1,24(sp)
 aea:	b7bd                	j	a58 <ithread_create+0x40>
    free(stack_ptr);
 aec:	8526                	mv	a0,s1
 aee:	00000097          	auipc	ra,0x0
 af2:	c9c080e7          	jalr	-868(ra) # 78a <free>
    stacks[num_threads] = 0;
 af6:	00000717          	auipc	a4,0x0
 afa:	53a72703          	lw	a4,1338(a4) # 1030 <num_threads>
 afe:	070e                	slli	a4,a4,0x3
 b00:	00000797          	auipc	a5,0x0
 b04:	5287b783          	ld	a5,1320(a5) # 1028 <stacks>
 b08:	97ba                	add	a5,a5,a4
 b0a:	0007b023          	sd	zero,0(a5)
 b0e:	64e2                	ld	s1,24(sp)
 b10:	bf61                	j	aa8 <ithread_create+0x90>

0000000000000b12 <ithread_join>:

int ithread_join(int thread_id) {
 b12:	1101                	addi	sp,sp,-32
 b14:	ec06                	sd	ra,24(sp)
 b16:	e822                	sd	s0,16(sp)
 b18:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b1a:	ff040793          	addi	a5,s0,-16
 b1e:	ffc7859b          	addiw	a1,a5,-4
 b22:	00000097          	auipc	ra,0x0
 b26:	90c080e7          	jalr	-1780(ra) # 42e <join_thread>
  threads_done++;
 b2a:	00000717          	auipc	a4,0x0
 b2e:	50a70713          	addi	a4,a4,1290 # 1034 <threads_done>
 b32:	431c                	lw	a5,0(a4)
 b34:	2785                	addiw	a5,a5,1
 b36:	0007869b          	sext.w	a3,a5
 b3a:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b3c:	00000797          	auipc	a5,0x0
 b40:	4f47a783          	lw	a5,1268(a5) # 1030 <num_threads>
 b44:	00d78863          	beq	a5,a3,b54 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 b48:	fec42503          	lw	a0,-20(s0)
 b4c:	60e2                	ld	ra,24(sp)
 b4e:	6442                	ld	s0,16(sp)
 b50:	6105                	addi	sp,sp,32
 b52:	8082                	ret
    free_stacks();
 b54:	00000097          	auipc	ra,0x0
 b58:	dd2080e7          	jalr	-558(ra) # 926 <free_stacks>
 b5c:	b7f5                	j	b48 <ithread_join+0x36>
