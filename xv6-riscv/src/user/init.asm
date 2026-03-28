
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
  12:	c6250513          	addi	a0,a0,-926 # c70 <ithread_join+0x52>
  16:	00000097          	auipc	ra,0x0
  1a:	4b4080e7          	jalr	1204(ra) # 4ca <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	4de080e7          	jalr	1246(ra) # 502 <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	4d4080e7          	jalr	1236(ra) # 502 <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	c4290913          	addi	s2,s2,-958 # c78 <ithread_join+0x5a>
  3e:	854a                	mv	a0,s2
  40:	00001097          	auipc	ra,0x1
  44:	820080e7          	jalr	-2016(ra) # 860 <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	43a080e7          	jalr	1082(ra) # 482 <fork>
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
  5e:	438080e7          	jalr	1080(ra) # 492 <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	c5e50513          	addi	a0,a0,-930 # cc8 <ithread_join+0xaa>
  72:	00000097          	auipc	ra,0x0
  76:	7ee080e7          	jalr	2030(ra) # 860 <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	40e080e7          	jalr	1038(ra) # 48a <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	be850513          	addi	a0,a0,-1048 # c70 <ithread_join+0x52>
  90:	00000097          	auipc	ra,0x0
  94:	442080e7          	jalr	1090(ra) # 4d2 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	bd650513          	addi	a0,a0,-1066 # c70 <ithread_join+0x52>
  a2:	00000097          	auipc	ra,0x0
  a6:	428080e7          	jalr	1064(ra) # 4ca <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	be450513          	addi	a0,a0,-1052 # c90 <ithread_join+0x72>
  b4:	00000097          	auipc	ra,0x0
  b8:	7ac080e7          	jalr	1964(ra) # 860 <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	3cc080e7          	jalr	972(ra) # 48a <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	f4a58593          	addi	a1,a1,-182 # 1010 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	bda50513          	addi	a0,a0,-1062 # ca8 <ithread_join+0x8a>
  d6:	00000097          	auipc	ra,0x0
  da:	3ec080e7          	jalr	1004(ra) # 4c2 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	bd250513          	addi	a0,a0,-1070 # cb0 <ithread_join+0x92>
  e6:	00000097          	auipc	ra,0x0
  ea:	77a080e7          	jalr	1914(ra) # 860 <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	39a080e7          	jalr	922(ra) # 48a <exit>

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
 10e:	380080e7          	jalr	896(ra) # 48a <exit>

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
 200:	2a6080e7          	jalr	678(ra) # 4a2 <read>
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

000000000000023e <fgetstdin>:

int
fgetstdin(char *buf, int size) {
 23e:	711d                	addi	sp,sp,-96
 240:	ec86                	sd	ra,88(sp)
 242:	e8a2                	sd	s0,80(sp)
 244:	e4a6                	sd	s1,72(sp)
 246:	e0ca                	sd	s2,64(sp)
 248:	fc4e                	sd	s3,56(sp)
 24a:	f852                	sd	s4,48(sp)
 24c:	f456                	sd	s5,40(sp)
 24e:	f05a                	sd	s6,32(sp)
 250:	ec5e                	sd	s7,24(sp)
 252:	1080                	addi	s0,sp,96
 254:	8baa                	mv	s7,a0
 256:	89ae                	mv	s3,a1
  int i, cc;
  char c;

  for(i=0; i+1 < size; ){
 258:	892a                	mv	s2,a0
 25a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 25c:	4aa9                	li	s5,10
 25e:	4b35                	li	s6,13
  for(i=0; i+1 < size; ){
 260:	8a26                	mv	s4,s1
 262:	2485                	addiw	s1,s1,1
 264:	0334d863          	bge	s1,s3,294 <fgetstdin+0x56>
    cc = read(0, &c, 1);
 268:	4605                	li	a2,1
 26a:	faf40593          	addi	a1,s0,-81
 26e:	4501                	li	a0,0
 270:	00000097          	auipc	ra,0x0
 274:	232080e7          	jalr	562(ra) # 4a2 <read>
    if(cc < 1)
 278:	00a05e63          	blez	a0,294 <fgetstdin+0x56>
    buf[i++] = c;
 27c:	faf44783          	lbu	a5,-81(s0)
 280:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 284:	01578763          	beq	a5,s5,292 <fgetstdin+0x54>
 288:	0905                	addi	s2,s2,1
 28a:	fd679be3          	bne	a5,s6,260 <fgetstdin+0x22>
    buf[i++] = c;
 28e:	8a26                	mv	s4,s1
 290:	a011                	j	294 <fgetstdin+0x56>
 292:	8a26                	mv	s4,s1
      break;
  }
  buf[i] = '\0';
 294:	9bd2                	add	s7,s7,s4
 296:	000b8023          	sb	zero,0(s7)
  return i;
}
 29a:	8552                	mv	a0,s4
 29c:	60e6                	ld	ra,88(sp)
 29e:	6446                	ld	s0,80(sp)
 2a0:	64a6                	ld	s1,72(sp)
 2a2:	6906                	ld	s2,64(sp)
 2a4:	79e2                	ld	s3,56(sp)
 2a6:	7a42                	ld	s4,48(sp)
 2a8:	7aa2                	ld	s5,40(sp)
 2aa:	7b02                	ld	s6,32(sp)
 2ac:	6be2                	ld	s7,24(sp)
 2ae:	6125                	addi	sp,sp,96
 2b0:	8082                	ret

00000000000002b2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b2:	1101                	addi	sp,sp,-32
 2b4:	ec06                	sd	ra,24(sp)
 2b6:	e822                	sd	s0,16(sp)
 2b8:	e04a                	sd	s2,0(sp)
 2ba:	1000                	addi	s0,sp,32
 2bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2be:	4581                	li	a1,0
 2c0:	00000097          	auipc	ra,0x0
 2c4:	20a080e7          	jalr	522(ra) # 4ca <open>
  if(fd < 0)
 2c8:	02054663          	bltz	a0,2f4 <stat+0x42>
 2cc:	e426                	sd	s1,8(sp)
 2ce:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d0:	85ca                	mv	a1,s2
 2d2:	00000097          	auipc	ra,0x0
 2d6:	210080e7          	jalr	528(ra) # 4e2 <fstat>
 2da:	892a                	mv	s2,a0
  close(fd);
 2dc:	8526                	mv	a0,s1
 2de:	00000097          	auipc	ra,0x0
 2e2:	1d4080e7          	jalr	468(ra) # 4b2 <close>
  return r;
 2e6:	64a2                	ld	s1,8(sp)
}
 2e8:	854a                	mv	a0,s2
 2ea:	60e2                	ld	ra,24(sp)
 2ec:	6442                	ld	s0,16(sp)
 2ee:	6902                	ld	s2,0(sp)
 2f0:	6105                	addi	sp,sp,32
 2f2:	8082                	ret
    return -1;
 2f4:	597d                	li	s2,-1
 2f6:	bfcd                	j	2e8 <stat+0x36>

00000000000002f8 <atoi>:

int
atoi(const char *s)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2fe:	00054683          	lbu	a3,0(a0)
 302:	fd06879b          	addiw	a5,a3,-48
 306:	0ff7f793          	zext.b	a5,a5
 30a:	4625                	li	a2,9
 30c:	02f66863          	bltu	a2,a5,33c <atoi+0x44>
 310:	872a                	mv	a4,a0
  n = 0;
 312:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 314:	0705                	addi	a4,a4,1
 316:	0025179b          	slliw	a5,a0,0x2
 31a:	9fa9                	addw	a5,a5,a0
 31c:	0017979b          	slliw	a5,a5,0x1
 320:	9fb5                	addw	a5,a5,a3
 322:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 326:	00074683          	lbu	a3,0(a4)
 32a:	fd06879b          	addiw	a5,a3,-48
 32e:	0ff7f793          	zext.b	a5,a5
 332:	fef671e3          	bgeu	a2,a5,314 <atoi+0x1c>
  return n;
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret
  n = 0;
 33c:	4501                	li	a0,0
 33e:	bfe5                	j	336 <atoi+0x3e>

0000000000000340 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 340:	1141                	addi	sp,sp,-16
 342:	e422                	sd	s0,8(sp)
 344:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 346:	02b57463          	bgeu	a0,a1,36e <memmove+0x2e>
    while(n-- > 0)
 34a:	00c05f63          	blez	a2,368 <memmove+0x28>
 34e:	1602                	slli	a2,a2,0x20
 350:	9201                	srli	a2,a2,0x20
 352:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 356:	872a                	mv	a4,a0
      *dst++ = *src++;
 358:	0585                	addi	a1,a1,1
 35a:	0705                	addi	a4,a4,1
 35c:	fff5c683          	lbu	a3,-1(a1)
 360:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 364:	fef71ae3          	bne	a4,a5,358 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret
    dst += n;
 36e:	00c50733          	add	a4,a0,a2
    src += n;
 372:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 374:	fec05ae3          	blez	a2,368 <memmove+0x28>
 378:	fff6079b          	addiw	a5,a2,-1
 37c:	1782                	slli	a5,a5,0x20
 37e:	9381                	srli	a5,a5,0x20
 380:	fff7c793          	not	a5,a5
 384:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 386:	15fd                	addi	a1,a1,-1
 388:	177d                	addi	a4,a4,-1
 38a:	0005c683          	lbu	a3,0(a1)
 38e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 392:	fee79ae3          	bne	a5,a4,386 <memmove+0x46>
 396:	bfc9                	j	368 <memmove+0x28>

0000000000000398 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 398:	1141                	addi	sp,sp,-16
 39a:	e422                	sd	s0,8(sp)
 39c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 39e:	ca05                	beqz	a2,3ce <memcmp+0x36>
 3a0:	fff6069b          	addiw	a3,a2,-1
 3a4:	1682                	slli	a3,a3,0x20
 3a6:	9281                	srli	a3,a3,0x20
 3a8:	0685                	addi	a3,a3,1
 3aa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ac:	00054783          	lbu	a5,0(a0)
 3b0:	0005c703          	lbu	a4,0(a1)
 3b4:	00e79863          	bne	a5,a4,3c4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3b8:	0505                	addi	a0,a0,1
    p2++;
 3ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3bc:	fed518e3          	bne	a0,a3,3ac <memcmp+0x14>
  }
  return 0;
 3c0:	4501                	li	a0,0
 3c2:	a019                	j	3c8 <memcmp+0x30>
      return *p1 - *p2;
 3c4:	40e7853b          	subw	a0,a5,a4
}
 3c8:	6422                	ld	s0,8(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret
  return 0;
 3ce:	4501                	li	a0,0
 3d0:	bfe5                	j	3c8 <memcmp+0x30>

00000000000003d2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3d2:	1141                	addi	sp,sp,-16
 3d4:	e406                	sd	ra,8(sp)
 3d6:	e022                	sd	s0,0(sp)
 3d8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3da:	00000097          	auipc	ra,0x0
 3de:	f66080e7          	jalr	-154(ra) # 340 <memmove>
}
 3e2:	60a2                	ld	ra,8(sp)
 3e4:	6402                	ld	s0,0(sp)
 3e6:	0141                	addi	sp,sp,16
 3e8:	8082                	ret

00000000000003ea <inet_addr>:

// Parse a dotted-decimal IPv4 string (e.g. "10.10.0.2") and return the
// address as a 32-bit integer in host byte order, or 0 on failure.
uint
inet_addr(const char *s)
{
 3ea:	1141                	addi	sp,sp,-16
 3ec:	e422                	sd	s0,8(sp)
 3ee:	0800                	addi	s0,sp,16
  uint result = 0;
  int octet = 0;
  int digits = 0;
  int dots = 0;

  for (; *s; s++) {
 3f0:	00054783          	lbu	a5,0(a0)
 3f4:	cfbd                	beqz	a5,472 <inet_addr+0x88>
  int dots = 0;
 3f6:	4801                	li	a6,0
  int digits = 0;
 3f8:	4601                	li	a2,0
  int octet = 0;
 3fa:	4681                	li	a3,0
  uint result = 0;
 3fc:	4581                	li	a1,0
    if (*s >= '0' && *s <= '9') {
 3fe:	48a5                	li	a7,9
      octet = octet * 10 + (*s - '0');
      digits++;
      if (octet > 255)
        return 0;
    } else if (*s == '.') {
 400:	02e00e93          	li	t4,46
      if (digits == 0 || dots == 3)
 404:	4f0d                	li	t5,3
        return 0;
      result = (result << 8) | (uint)octet;
      octet = 0;
      digits = 0;
 406:	4301                	li	t1,0
      if (octet > 255)
 408:	0ff00e13          	li	t3,255
 40c:	a015                	j	430 <inet_addr+0x46>
    } else if (*s == '.') {
 40e:	07d79463          	bne	a5,t4,476 <inet_addr+0x8c>
      if (digits == 0 || dots == 3)
 412:	c625                	beqz	a2,47a <inet_addr+0x90>
 414:	07e80563          	beq	a6,t5,47e <inet_addr+0x94>
      result = (result << 8) | (uint)octet;
 418:	0085959b          	slliw	a1,a1,0x8
 41c:	8ecd                	or	a3,a3,a1
 41e:	0006859b          	sext.w	a1,a3
      dots++;
 422:	2805                	addiw	a6,a6,1
      digits = 0;
 424:	861a                	mv	a2,t1
      octet = 0;
 426:	869a                	mv	a3,t1
  for (; *s; s++) {
 428:	0505                	addi	a0,a0,1
 42a:	00054783          	lbu	a5,0(a0)
 42e:	c79d                	beqz	a5,45c <inet_addr+0x72>
    if (*s >= '0' && *s <= '9') {
 430:	fd07871b          	addiw	a4,a5,-48
 434:	0ff77713          	zext.b	a4,a4
 438:	fce8ebe3          	bltu	a7,a4,40e <inet_addr+0x24>
      octet = octet * 10 + (*s - '0');
 43c:	0026971b          	slliw	a4,a3,0x2
 440:	9f35                	addw	a4,a4,a3
 442:	0017171b          	slliw	a4,a4,0x1
 446:	fd07879b          	addiw	a5,a5,-48
 44a:	00e786bb          	addw	a3,a5,a4
      digits++;
 44e:	2605                	addiw	a2,a2,1
      if (octet > 255)
 450:	fcde5ce3          	bge	t3,a3,428 <inet_addr+0x3e>
        return 0;
 454:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
    return 0;

  result = (result << 8) | (uint)octet;
  return result;
}
 456:	6422                	ld	s0,8(sp)
 458:	0141                	addi	sp,sp,16
 45a:	8082                	ret
    return 0;
 45c:	4501                	li	a0,0
  if (digits == 0 || dots != 3)
 45e:	de65                	beqz	a2,456 <inet_addr+0x6c>
 460:	478d                	li	a5,3
 462:	fef81ae3          	bne	a6,a5,456 <inet_addr+0x6c>
  result = (result << 8) | (uint)octet;
 466:	0085959b          	slliw	a1,a1,0x8
 46a:	8ecd                	or	a3,a3,a1
 46c:	0006851b          	sext.w	a0,a3
  return result;
 470:	b7dd                	j	456 <inet_addr+0x6c>
    return 0;
 472:	4501                	li	a0,0
 474:	b7cd                	j	456 <inet_addr+0x6c>
      return 0;
 476:	4501                	li	a0,0
 478:	bff9                	j	456 <inet_addr+0x6c>
        return 0;
 47a:	4501                	li	a0,0
 47c:	bfe9                	j	456 <inet_addr+0x6c>
 47e:	4501                	li	a0,0
 480:	bfd9                	j	456 <inet_addr+0x6c>

0000000000000482 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 482:	4885                	li	a7,1
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <exit>:
.global exit
exit:
 li a7, SYS_exit
 48a:	4889                	li	a7,2
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <wait>:
.global wait
wait:
 li a7, SYS_wait
 492:	488d                	li	a7,3
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 49a:	4891                	li	a7,4
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <read>:
.global read
read:
 li a7, SYS_read
 4a2:	4895                	li	a7,5
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <write>:
.global write
write:
 li a7, SYS_write
 4aa:	48c1                	li	a7,16
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <close>:
.global close
close:
 li a7, SYS_close
 4b2:	48d5                	li	a7,21
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 4ba:	4899                	li	a7,6
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4c2:	489d                	li	a7,7
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <open>:
.global open
open:
 li a7, SYS_open
 4ca:	48bd                	li	a7,15
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4d2:	48c5                	li	a7,17
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4da:	48c9                	li	a7,18
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4e2:	48a1                	li	a7,8
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <link>:
.global link
link:
 li a7, SYS_link
 4ea:	48cd                	li	a7,19
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4f2:	48d1                	li	a7,20
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4fa:	48a5                	li	a7,9
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <dup>:
.global dup
dup:
 li a7, SYS_dup
 502:	48a9                	li	a7,10
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 50a:	48ad                	li	a7,11
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 512:	48b1                	li	a7,12
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 51a:	48b5                	li	a7,13
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 522:	48b9                	li	a7,14
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 52a:	48d9                	li	a7,22
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 532:	48dd                	li	a7,23
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 53a:	48e1                	li	a7,24
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 542:	48e5                	li	a7,25
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <socket>:
.global socket
socket:
 li a7, SYS_socket
 54a:	48e9                	li	a7,26
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <bind>:
.global bind
bind:
 li a7, SYS_bind
 552:	48ed                	li	a7,27
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <accept>:
.global accept
accept:
 li a7, SYS_accept
 55a:	48f5                	li	a7,29
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <listen>:
.global listen
listen:
 li a7, SYS_listen
 562:	48f1                	li	a7,28
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <connect>:
.global connect
connect:
 li a7, SYS_connect
 56a:	48f9                	li	a7,30
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <send>:
.global send
send:
 li a7, SYS_send
 572:	48fd                	li	a7,31
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <recv>:
.global recv
recv:
 li a7, SYS_recv
 57a:	02000893          	li	a7,32
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 584:	02100893          	li	a7,33
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 58e:	02200893          	li	a7,34
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 598:	1101                	addi	sp,sp,-32
 59a:	ec06                	sd	ra,24(sp)
 59c:	e822                	sd	s0,16(sp)
 59e:	1000                	addi	s0,sp,32
 5a0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5a4:	4605                	li	a2,1
 5a6:	fef40593          	addi	a1,s0,-17
 5aa:	00000097          	auipc	ra,0x0
 5ae:	f00080e7          	jalr	-256(ra) # 4aa <write>
}
 5b2:	60e2                	ld	ra,24(sp)
 5b4:	6442                	ld	s0,16(sp)
 5b6:	6105                	addi	sp,sp,32
 5b8:	8082                	ret

00000000000005ba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ba:	7139                	addi	sp,sp,-64
 5bc:	fc06                	sd	ra,56(sp)
 5be:	f822                	sd	s0,48(sp)
 5c0:	f426                	sd	s1,40(sp)
 5c2:	0080                	addi	s0,sp,64
 5c4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5c6:	c299                	beqz	a3,5cc <printint+0x12>
 5c8:	0805cb63          	bltz	a1,65e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5cc:	2581                	sext.w	a1,a1
  neg = 0;
 5ce:	4881                	li	a7,0
 5d0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5d4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5d6:	2601                	sext.w	a2,a2
 5d8:	00000517          	auipc	a0,0x0
 5dc:	7a050513          	addi	a0,a0,1952 # d78 <digits>
 5e0:	883a                	mv	a6,a4
 5e2:	2705                	addiw	a4,a4,1
 5e4:	02c5f7bb          	remuw	a5,a1,a2
 5e8:	1782                	slli	a5,a5,0x20
 5ea:	9381                	srli	a5,a5,0x20
 5ec:	97aa                	add	a5,a5,a0
 5ee:	0007c783          	lbu	a5,0(a5)
 5f2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5f6:	0005879b          	sext.w	a5,a1
 5fa:	02c5d5bb          	divuw	a1,a1,a2
 5fe:	0685                	addi	a3,a3,1
 600:	fec7f0e3          	bgeu	a5,a2,5e0 <printint+0x26>
  if(neg)
 604:	00088c63          	beqz	a7,61c <printint+0x62>
    buf[i++] = '-';
 608:	fd070793          	addi	a5,a4,-48
 60c:	00878733          	add	a4,a5,s0
 610:	02d00793          	li	a5,45
 614:	fef70823          	sb	a5,-16(a4)
 618:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 61c:	02e05c63          	blez	a4,654 <printint+0x9a>
 620:	f04a                	sd	s2,32(sp)
 622:	ec4e                	sd	s3,24(sp)
 624:	fc040793          	addi	a5,s0,-64
 628:	00e78933          	add	s2,a5,a4
 62c:	fff78993          	addi	s3,a5,-1
 630:	99ba                	add	s3,s3,a4
 632:	377d                	addiw	a4,a4,-1
 634:	1702                	slli	a4,a4,0x20
 636:	9301                	srli	a4,a4,0x20
 638:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 63c:	fff94583          	lbu	a1,-1(s2)
 640:	8526                	mv	a0,s1
 642:	00000097          	auipc	ra,0x0
 646:	f56080e7          	jalr	-170(ra) # 598 <putc>
  while(--i >= 0)
 64a:	197d                	addi	s2,s2,-1
 64c:	ff3918e3          	bne	s2,s3,63c <printint+0x82>
 650:	7902                	ld	s2,32(sp)
 652:	69e2                	ld	s3,24(sp)
}
 654:	70e2                	ld	ra,56(sp)
 656:	7442                	ld	s0,48(sp)
 658:	74a2                	ld	s1,40(sp)
 65a:	6121                	addi	sp,sp,64
 65c:	8082                	ret
    x = -xx;
 65e:	40b005bb          	negw	a1,a1
    neg = 1;
 662:	4885                	li	a7,1
    x = -xx;
 664:	b7b5                	j	5d0 <printint+0x16>

0000000000000666 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 666:	715d                	addi	sp,sp,-80
 668:	e486                	sd	ra,72(sp)
 66a:	e0a2                	sd	s0,64(sp)
 66c:	f84a                	sd	s2,48(sp)
 66e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 670:	0005c903          	lbu	s2,0(a1)
 674:	1a090a63          	beqz	s2,828 <vprintf+0x1c2>
 678:	fc26                	sd	s1,56(sp)
 67a:	f44e                	sd	s3,40(sp)
 67c:	f052                	sd	s4,32(sp)
 67e:	ec56                	sd	s5,24(sp)
 680:	e85a                	sd	s6,16(sp)
 682:	e45e                	sd	s7,8(sp)
 684:	8aaa                	mv	s5,a0
 686:	8bb2                	mv	s7,a2
 688:	00158493          	addi	s1,a1,1
  state = 0;
 68c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 68e:	02500a13          	li	s4,37
 692:	4b55                	li	s6,21
 694:	a839                	j	6b2 <vprintf+0x4c>
        putc(fd, c);
 696:	85ca                	mv	a1,s2
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	efe080e7          	jalr	-258(ra) # 598 <putc>
 6a2:	a019                	j	6a8 <vprintf+0x42>
    } else if(state == '%'){
 6a4:	01498d63          	beq	s3,s4,6be <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 6a8:	0485                	addi	s1,s1,1
 6aa:	fff4c903          	lbu	s2,-1(s1)
 6ae:	16090763          	beqz	s2,81c <vprintf+0x1b6>
    if(state == 0){
 6b2:	fe0999e3          	bnez	s3,6a4 <vprintf+0x3e>
      if(c == '%'){
 6b6:	ff4910e3          	bne	s2,s4,696 <vprintf+0x30>
        state = '%';
 6ba:	89d2                	mv	s3,s4
 6bc:	b7f5                	j	6a8 <vprintf+0x42>
      if(c == 'd'){
 6be:	13490463          	beq	s2,s4,7e6 <vprintf+0x180>
 6c2:	f9d9079b          	addiw	a5,s2,-99
 6c6:	0ff7f793          	zext.b	a5,a5
 6ca:	12fb6763          	bltu	s6,a5,7f8 <vprintf+0x192>
 6ce:	f9d9079b          	addiw	a5,s2,-99
 6d2:	0ff7f713          	zext.b	a4,a5
 6d6:	12eb6163          	bltu	s6,a4,7f8 <vprintf+0x192>
 6da:	00271793          	slli	a5,a4,0x2
 6de:	00000717          	auipc	a4,0x0
 6e2:	64270713          	addi	a4,a4,1602 # d20 <ithread_join+0x102>
 6e6:	97ba                	add	a5,a5,a4
 6e8:	439c                	lw	a5,0(a5)
 6ea:	97ba                	add	a5,a5,a4
 6ec:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6ee:	008b8913          	addi	s2,s7,8
 6f2:	4685                	li	a3,1
 6f4:	4629                	li	a2,10
 6f6:	000ba583          	lw	a1,0(s7)
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	ebe080e7          	jalr	-322(ra) # 5ba <printint>
 704:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 706:	4981                	li	s3,0
 708:	b745                	j	6a8 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 70a:	008b8913          	addi	s2,s7,8
 70e:	4681                	li	a3,0
 710:	4629                	li	a2,10
 712:	000ba583          	lw	a1,0(s7)
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	ea2080e7          	jalr	-350(ra) # 5ba <printint>
 720:	8bca                	mv	s7,s2
      state = 0;
 722:	4981                	li	s3,0
 724:	b751                	j	6a8 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 726:	008b8913          	addi	s2,s7,8
 72a:	4681                	li	a3,0
 72c:	4641                	li	a2,16
 72e:	000ba583          	lw	a1,0(s7)
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	e86080e7          	jalr	-378(ra) # 5ba <printint>
 73c:	8bca                	mv	s7,s2
      state = 0;
 73e:	4981                	li	s3,0
 740:	b7a5                	j	6a8 <vprintf+0x42>
 742:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 744:	008b8c13          	addi	s8,s7,8
 748:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 74c:	03000593          	li	a1,48
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	e46080e7          	jalr	-442(ra) # 598 <putc>
  putc(fd, 'x');
 75a:	07800593          	li	a1,120
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	e38080e7          	jalr	-456(ra) # 598 <putc>
 768:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 76a:	00000b97          	auipc	s7,0x0
 76e:	60eb8b93          	addi	s7,s7,1550 # d78 <digits>
 772:	03c9d793          	srli	a5,s3,0x3c
 776:	97de                	add	a5,a5,s7
 778:	0007c583          	lbu	a1,0(a5)
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	e1a080e7          	jalr	-486(ra) # 598 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 786:	0992                	slli	s3,s3,0x4
 788:	397d                	addiw	s2,s2,-1
 78a:	fe0914e3          	bnez	s2,772 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 78e:	8be2                	mv	s7,s8
      state = 0;
 790:	4981                	li	s3,0
 792:	6c02                	ld	s8,0(sp)
 794:	bf11                	j	6a8 <vprintf+0x42>
        s = va_arg(ap, char*);
 796:	008b8993          	addi	s3,s7,8
 79a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 79e:	02090163          	beqz	s2,7c0 <vprintf+0x15a>
        while(*s != 0){
 7a2:	00094583          	lbu	a1,0(s2)
 7a6:	c9a5                	beqz	a1,816 <vprintf+0x1b0>
          putc(fd, *s);
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	dee080e7          	jalr	-530(ra) # 598 <putc>
          s++;
 7b2:	0905                	addi	s2,s2,1
        while(*s != 0){
 7b4:	00094583          	lbu	a1,0(s2)
 7b8:	f9e5                	bnez	a1,7a8 <vprintf+0x142>
        s = va_arg(ap, char*);
 7ba:	8bce                	mv	s7,s3
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	b5ed                	j	6a8 <vprintf+0x42>
          s = "(null)";
 7c0:	00000917          	auipc	s2,0x0
 7c4:	52890913          	addi	s2,s2,1320 # ce8 <ithread_join+0xca>
        while(*s != 0){
 7c8:	02800593          	li	a1,40
 7cc:	bff1                	j	7a8 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 7ce:	008b8913          	addi	s2,s7,8
 7d2:	000bc583          	lbu	a1,0(s7)
 7d6:	8556                	mv	a0,s5
 7d8:	00000097          	auipc	ra,0x0
 7dc:	dc0080e7          	jalr	-576(ra) # 598 <putc>
 7e0:	8bca                	mv	s7,s2
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	b5d1                	j	6a8 <vprintf+0x42>
        putc(fd, c);
 7e6:	02500593          	li	a1,37
 7ea:	8556                	mv	a0,s5
 7ec:	00000097          	auipc	ra,0x0
 7f0:	dac080e7          	jalr	-596(ra) # 598 <putc>
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	bd4d                	j	6a8 <vprintf+0x42>
        putc(fd, '%');
 7f8:	02500593          	li	a1,37
 7fc:	8556                	mv	a0,s5
 7fe:	00000097          	auipc	ra,0x0
 802:	d9a080e7          	jalr	-614(ra) # 598 <putc>
        putc(fd, c);
 806:	85ca                	mv	a1,s2
 808:	8556                	mv	a0,s5
 80a:	00000097          	auipc	ra,0x0
 80e:	d8e080e7          	jalr	-626(ra) # 598 <putc>
      state = 0;
 812:	4981                	li	s3,0
 814:	bd51                	j	6a8 <vprintf+0x42>
        s = va_arg(ap, char*);
 816:	8bce                	mv	s7,s3
      state = 0;
 818:	4981                	li	s3,0
 81a:	b579                	j	6a8 <vprintf+0x42>
 81c:	74e2                	ld	s1,56(sp)
 81e:	79a2                	ld	s3,40(sp)
 820:	7a02                	ld	s4,32(sp)
 822:	6ae2                	ld	s5,24(sp)
 824:	6b42                	ld	s6,16(sp)
 826:	6ba2                	ld	s7,8(sp)
    }
  }
}
 828:	60a6                	ld	ra,72(sp)
 82a:	6406                	ld	s0,64(sp)
 82c:	7942                	ld	s2,48(sp)
 82e:	6161                	addi	sp,sp,80
 830:	8082                	ret

0000000000000832 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 832:	715d                	addi	sp,sp,-80
 834:	ec06                	sd	ra,24(sp)
 836:	e822                	sd	s0,16(sp)
 838:	1000                	addi	s0,sp,32
 83a:	e010                	sd	a2,0(s0)
 83c:	e414                	sd	a3,8(s0)
 83e:	e818                	sd	a4,16(s0)
 840:	ec1c                	sd	a5,24(s0)
 842:	03043023          	sd	a6,32(s0)
 846:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 84a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 84e:	8622                	mv	a2,s0
 850:	00000097          	auipc	ra,0x0
 854:	e16080e7          	jalr	-490(ra) # 666 <vprintf>
}
 858:	60e2                	ld	ra,24(sp)
 85a:	6442                	ld	s0,16(sp)
 85c:	6161                	addi	sp,sp,80
 85e:	8082                	ret

0000000000000860 <printf>:

void
printf(const char *fmt, ...)
{
 860:	711d                	addi	sp,sp,-96
 862:	ec06                	sd	ra,24(sp)
 864:	e822                	sd	s0,16(sp)
 866:	1000                	addi	s0,sp,32
 868:	e40c                	sd	a1,8(s0)
 86a:	e810                	sd	a2,16(s0)
 86c:	ec14                	sd	a3,24(s0)
 86e:	f018                	sd	a4,32(s0)
 870:	f41c                	sd	a5,40(s0)
 872:	03043823          	sd	a6,48(s0)
 876:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 87a:	00840613          	addi	a2,s0,8
 87e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 882:	85aa                	mv	a1,a0
 884:	4505                	li	a0,1
 886:	00000097          	auipc	ra,0x0
 88a:	de0080e7          	jalr	-544(ra) # 666 <vprintf>
}
 88e:	60e2                	ld	ra,24(sp)
 890:	6442                	ld	s0,16(sp)
 892:	6125                	addi	sp,sp,96
 894:	8082                	ret

0000000000000896 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 896:	1141                	addi	sp,sp,-16
 898:	e422                	sd	s0,8(sp)
 89a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 89c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a0:	00000797          	auipc	a5,0x0
 8a4:	7807b783          	ld	a5,1920(a5) # 1020 <freep>
 8a8:	a02d                	j	8d2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8aa:	4618                	lw	a4,8(a2)
 8ac:	9f2d                	addw	a4,a4,a1
 8ae:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b2:	6398                	ld	a4,0(a5)
 8b4:	6310                	ld	a2,0(a4)
 8b6:	a83d                	j	8f4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8b8:	ff852703          	lw	a4,-8(a0)
 8bc:	9f31                	addw	a4,a4,a2
 8be:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8c0:	ff053683          	ld	a3,-16(a0)
 8c4:	a091                	j	908 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c6:	6398                	ld	a4,0(a5)
 8c8:	00e7e463          	bltu	a5,a4,8d0 <free+0x3a>
 8cc:	00e6ea63          	bltu	a3,a4,8e0 <free+0x4a>
{
 8d0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d2:	fed7fae3          	bgeu	a5,a3,8c6 <free+0x30>
 8d6:	6398                	ld	a4,0(a5)
 8d8:	00e6e463          	bltu	a3,a4,8e0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8dc:	fee7eae3          	bltu	a5,a4,8d0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8e0:	ff852583          	lw	a1,-8(a0)
 8e4:	6390                	ld	a2,0(a5)
 8e6:	02059813          	slli	a6,a1,0x20
 8ea:	01c85713          	srli	a4,a6,0x1c
 8ee:	9736                	add	a4,a4,a3
 8f0:	fae60de3          	beq	a2,a4,8aa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8f4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8f8:	4790                	lw	a2,8(a5)
 8fa:	02061593          	slli	a1,a2,0x20
 8fe:	01c5d713          	srli	a4,a1,0x1c
 902:	973e                	add	a4,a4,a5
 904:	fae68ae3          	beq	a3,a4,8b8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 908:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 90a:	00000717          	auipc	a4,0x0
 90e:	70f73b23          	sd	a5,1814(a4) # 1020 <freep>
}
 912:	6422                	ld	s0,8(sp)
 914:	0141                	addi	sp,sp,16
 916:	8082                	ret

0000000000000918 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 918:	7139                	addi	sp,sp,-64
 91a:	fc06                	sd	ra,56(sp)
 91c:	f822                	sd	s0,48(sp)
 91e:	f426                	sd	s1,40(sp)
 920:	ec4e                	sd	s3,24(sp)
 922:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 924:	02051493          	slli	s1,a0,0x20
 928:	9081                	srli	s1,s1,0x20
 92a:	04bd                	addi	s1,s1,15
 92c:	8091                	srli	s1,s1,0x4
 92e:	0014899b          	addiw	s3,s1,1
 932:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 934:	00000517          	auipc	a0,0x0
 938:	6ec53503          	ld	a0,1772(a0) # 1020 <freep>
 93c:	c915                	beqz	a0,970 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 940:	4798                	lw	a4,8(a5)
 942:	08977e63          	bgeu	a4,s1,9de <malloc+0xc6>
 946:	f04a                	sd	s2,32(sp)
 948:	e852                	sd	s4,16(sp)
 94a:	e456                	sd	s5,8(sp)
 94c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 94e:	8a4e                	mv	s4,s3
 950:	0009871b          	sext.w	a4,s3
 954:	6685                	lui	a3,0x1
 956:	00d77363          	bgeu	a4,a3,95c <malloc+0x44>
 95a:	6a05                	lui	s4,0x1
 95c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 960:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 964:	00000917          	auipc	s2,0x0
 968:	6bc90913          	addi	s2,s2,1724 # 1020 <freep>
  if(p == (char*)-1)
 96c:	5afd                	li	s5,-1
 96e:	a091                	j	9b2 <malloc+0x9a>
 970:	f04a                	sd	s2,32(sp)
 972:	e852                	sd	s4,16(sp)
 974:	e456                	sd	s5,8(sp)
 976:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 978:	00000797          	auipc	a5,0x0
 97c:	6c878793          	addi	a5,a5,1736 # 1040 <base>
 980:	00000717          	auipc	a4,0x0
 984:	6af73023          	sd	a5,1696(a4) # 1020 <freep>
 988:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 98a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 98e:	b7c1                	j	94e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 990:	6398                	ld	a4,0(a5)
 992:	e118                	sd	a4,0(a0)
 994:	a08d                	j	9f6 <malloc+0xde>
  hp->s.size = nu;
 996:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 99a:	0541                	addi	a0,a0,16
 99c:	00000097          	auipc	ra,0x0
 9a0:	efa080e7          	jalr	-262(ra) # 896 <free>
  return freep;
 9a4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9a8:	c13d                	beqz	a0,a0e <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9ac:	4798                	lw	a4,8(a5)
 9ae:	02977463          	bgeu	a4,s1,9d6 <malloc+0xbe>
    if(p == freep)
 9b2:	00093703          	ld	a4,0(s2)
 9b6:	853e                	mv	a0,a5
 9b8:	fef719e3          	bne	a4,a5,9aa <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 9bc:	8552                	mv	a0,s4
 9be:	00000097          	auipc	ra,0x0
 9c2:	b54080e7          	jalr	-1196(ra) # 512 <sbrk>
  if(p == (char*)-1)
 9c6:	fd5518e3          	bne	a0,s5,996 <malloc+0x7e>
        return 0;
 9ca:	4501                	li	a0,0
 9cc:	7902                	ld	s2,32(sp)
 9ce:	6a42                	ld	s4,16(sp)
 9d0:	6aa2                	ld	s5,8(sp)
 9d2:	6b02                	ld	s6,0(sp)
 9d4:	a03d                	j	a02 <malloc+0xea>
 9d6:	7902                	ld	s2,32(sp)
 9d8:	6a42                	ld	s4,16(sp)
 9da:	6aa2                	ld	s5,8(sp)
 9dc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9de:	fae489e3          	beq	s1,a4,990 <malloc+0x78>
        p->s.size -= nunits;
 9e2:	4137073b          	subw	a4,a4,s3
 9e6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e8:	02071693          	slli	a3,a4,0x20
 9ec:	01c6d713          	srli	a4,a3,0x1c
 9f0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9f2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9f6:	00000717          	auipc	a4,0x0
 9fa:	62a73523          	sd	a0,1578(a4) # 1020 <freep>
      return (void*)(p + 1);
 9fe:	01078513          	addi	a0,a5,16
  }
}
 a02:	70e2                	ld	ra,56(sp)
 a04:	7442                	ld	s0,48(sp)
 a06:	74a2                	ld	s1,40(sp)
 a08:	69e2                	ld	s3,24(sp)
 a0a:	6121                	addi	sp,sp,64
 a0c:	8082                	ret
 a0e:	7902                	ld	s2,32(sp)
 a10:	6a42                	ld	s4,16(sp)
 a12:	6aa2                	ld	s5,8(sp)
 a14:	6b02                	ld	s6,0(sp)
 a16:	b7f5                	j	a02 <malloc+0xea>

0000000000000a18 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 a18:	1141                	addi	sp,sp,-16
 a1a:	e406                	sd	ra,8(sp)
 a1c:	e022                	sd	s0,0(sp)
 a1e:	0800                	addi	s0,sp,16
  thread_exit(status);
 a20:	2501                	sext.w	a0,a0
 a22:	00000097          	auipc	ra,0x0
 a26:	b20080e7          	jalr	-1248(ra) # 542 <thread_exit>
}
 a2a:	60a2                	ld	ra,8(sp)
 a2c:	6402                	ld	s0,0(sp)
 a2e:	0141                	addi	sp,sp,16
 a30:	8082                	ret

0000000000000a32 <free_stacks>:
int free_stacks() {
 a32:	7179                	addi	sp,sp,-48
 a34:	f406                	sd	ra,40(sp)
 a36:	f022                	sd	s0,32(sp)
 a38:	ec26                	sd	s1,24(sp)
 a3a:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 a3c:	00000797          	auipc	a5,0x0
 a40:	5f47a783          	lw	a5,1524(a5) # 1030 <num_threads>
 a44:	04f05063          	blez	a5,a84 <free_stacks+0x52>
 a48:	e84a                	sd	s2,16(sp)
 a4a:	e44e                	sd	s3,8(sp)
 a4c:	4481                	li	s1,0
    free(stacks[i]);
 a4e:	00000997          	auipc	s3,0x0
 a52:	5da98993          	addi	s3,s3,1498 # 1028 <stacks>
  for (int i = 0; i < num_threads; i++) {
 a56:	00000917          	auipc	s2,0x0
 a5a:	5da90913          	addi	s2,s2,1498 # 1030 <num_threads>
    free(stacks[i]);
 a5e:	0009b783          	ld	a5,0(s3)
 a62:	00349713          	slli	a4,s1,0x3
 a66:	97ba                	add	a5,a5,a4
 a68:	6388                	ld	a0,0(a5)
 a6a:	00000097          	auipc	ra,0x0
 a6e:	e2c080e7          	jalr	-468(ra) # 896 <free>
  for (int i = 0; i < num_threads; i++) {
 a72:	0485                	addi	s1,s1,1
 a74:	00092703          	lw	a4,0(s2)
 a78:	0004879b          	sext.w	a5,s1
 a7c:	fee7c1e3          	blt	a5,a4,a5e <free_stacks+0x2c>
 a80:	6942                	ld	s2,16(sp)
 a82:	69a2                	ld	s3,8(sp)
  free(stacks);
 a84:	00000497          	auipc	s1,0x0
 a88:	5a448493          	addi	s1,s1,1444 # 1028 <stacks>
 a8c:	6088                	ld	a0,0(s1)
 a8e:	00000097          	auipc	ra,0x0
 a92:	e08080e7          	jalr	-504(ra) # 896 <free>
  stacks = 0;
 a96:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 a9a:	00000797          	auipc	a5,0x0
 a9e:	5807ab23          	sw	zero,1430(a5) # 1030 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 aa2:	47a1                	li	a5,8
 aa4:	00000717          	auipc	a4,0x0
 aa8:	54f72e23          	sw	a5,1372(a4) # 1000 <max_stacks>
  threads_done = 0;
 aac:	00000797          	auipc	a5,0x0
 ab0:	5807a423          	sw	zero,1416(a5) # 1034 <threads_done>
}
 ab4:	4501                	li	a0,0
 ab6:	70a2                	ld	ra,40(sp)
 ab8:	7402                	ld	s0,32(sp)
 aba:	64e2                	ld	s1,24(sp)
 abc:	6145                	addi	sp,sp,48
 abe:	8082                	ret

0000000000000ac0 <expand_num_threads>:
int expand_num_threads() {
 ac0:	1101                	addi	sp,sp,-32
 ac2:	ec06                	sd	ra,24(sp)
 ac4:	e822                	sd	s0,16(sp)
 ac6:	e426                	sd	s1,8(sp)
 ac8:	e04a                	sd	s2,0(sp)
 aca:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 acc:	00000797          	auipc	a5,0x0
 ad0:	53478793          	addi	a5,a5,1332 # 1000 <max_stacks>
 ad4:	4388                	lw	a0,0(a5)
 ad6:	0015151b          	slliw	a0,a0,0x1
 ada:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 adc:	0035151b          	slliw	a0,a0,0x3
 ae0:	00000097          	auipc	ra,0x0
 ae4:	e38080e7          	jalr	-456(ra) # 918 <malloc>
 ae8:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 aea:	00000617          	auipc	a2,0x0
 aee:	54662603          	lw	a2,1350(a2) # 1030 <num_threads>
 af2:	00000497          	auipc	s1,0x0
 af6:	53648493          	addi	s1,s1,1334 # 1028 <stacks>
 afa:	0036161b          	slliw	a2,a2,0x3
 afe:	608c                	ld	a1,0(s1)
 b00:	00000097          	auipc	ra,0x0
 b04:	840080e7          	jalr	-1984(ra) # 340 <memmove>
  free(stacks);
 b08:	6088                	ld	a0,0(s1)
 b0a:	00000097          	auipc	ra,0x0
 b0e:	d8c080e7          	jalr	-628(ra) # 896 <free>
  stacks = new_stacks;
 b12:	0124b023          	sd	s2,0(s1)
}
 b16:	4501                	li	a0,0
 b18:	60e2                	ld	ra,24(sp)
 b1a:	6442                	ld	s0,16(sp)
 b1c:	64a2                	ld	s1,8(sp)
 b1e:	6902                	ld	s2,0(sp)
 b20:	6105                	addi	sp,sp,32
 b22:	8082                	ret

0000000000000b24 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 b24:	7179                	addi	sp,sp,-48
 b26:	f406                	sd	ra,40(sp)
 b28:	f022                	sd	s0,32(sp)
 b2a:	e84a                	sd	s2,16(sp)
 b2c:	e44e                	sd	s3,8(sp)
 b2e:	1800                	addi	s0,sp,48
 b30:	892a                	mv	s2,a0
 b32:	89ae                	mv	s3,a1
  if (stacks == 0) {
 b34:	00000797          	auipc	a5,0x0
 b38:	4f47b783          	ld	a5,1268(a5) # 1028 <stacks>
 b3c:	c3d9                	beqz	a5,bc2 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 b3e:	00000797          	auipc	a5,0x0
 b42:	4c27a783          	lw	a5,1218(a5) # 1000 <max_stacks>
 b46:	00000717          	auipc	a4,0x0
 b4a:	4ea72703          	lw	a4,1258(a4) # 1030 <num_threads>
 b4e:	0af71363          	bne	a4,a5,bf4 <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 b52:	04000713          	li	a4,64
 b56:	08e78563          	beq	a5,a4,be0 <ithread_create+0xbc>
 b5a:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 b5c:	00000097          	auipc	ra,0x0
 b60:	f64080e7          	jalr	-156(ra) # ac0 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 b64:	6505                	lui	a0,0x1
 b66:	00000097          	auipc	ra,0x0
 b6a:	db2080e7          	jalr	-590(ra) # 918 <malloc>
 b6e:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 b70:	00000717          	auipc	a4,0x0
 b74:	4c072703          	lw	a4,1216(a4) # 1030 <num_threads>
 b78:	070e                	slli	a4,a4,0x3
 b7a:	00000797          	auipc	a5,0x0
 b7e:	4ae7b783          	ld	a5,1198(a5) # 1028 <stacks>
 b82:	97ba                	add	a5,a5,a4
 b84:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 b86:	00000697          	auipc	a3,0x0
 b8a:	e9268693          	addi	a3,a3,-366 # a18 <ithread_exit>
 b8e:	862a                	mv	a2,a0
 b90:	85ce                	mv	a1,s3
 b92:	854a                	mv	a0,s2
 b94:	00000097          	auipc	ra,0x0
 b98:	99e080e7          	jalr	-1634(ra) # 532 <create_thread>
 b9c:	892a                	mv	s2,a0
  if (res != -1) {
 b9e:	57fd                	li	a5,-1
 ba0:	04f50c63          	beq	a0,a5,bf8 <ithread_create+0xd4>
    num_threads++;
 ba4:	00000717          	auipc	a4,0x0
 ba8:	48c70713          	addi	a4,a4,1164 # 1030 <num_threads>
 bac:	431c                	lw	a5,0(a4)
 bae:	2785                	addiw	a5,a5,1
 bb0:	c31c                	sw	a5,0(a4)
 bb2:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 bb4:	854a                	mv	a0,s2
 bb6:	70a2                	ld	ra,40(sp)
 bb8:	7402                	ld	s0,32(sp)
 bba:	6942                	ld	s2,16(sp)
 bbc:	69a2                	ld	s3,8(sp)
 bbe:	6145                	addi	sp,sp,48
 bc0:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 bc2:	00000517          	auipc	a0,0x0
 bc6:	43e52503          	lw	a0,1086(a0) # 1000 <max_stacks>
 bca:	0035151b          	slliw	a0,a0,0x3
 bce:	00000097          	auipc	ra,0x0
 bd2:	d4a080e7          	jalr	-694(ra) # 918 <malloc>
 bd6:	00000797          	auipc	a5,0x0
 bda:	44a7b923          	sd	a0,1106(a5) # 1028 <stacks>
 bde:	b785                	j	b3e <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 be0:	00000517          	auipc	a0,0x0
 be4:	11050513          	addi	a0,a0,272 # cf0 <ithread_join+0xd2>
 be8:	00000097          	auipc	ra,0x0
 bec:	c78080e7          	jalr	-904(ra) # 860 <printf>
      return -1;
 bf0:	597d                	li	s2,-1
 bf2:	b7c9                	j	bb4 <ithread_create+0x90>
 bf4:	ec26                	sd	s1,24(sp)
 bf6:	b7bd                	j	b64 <ithread_create+0x40>
    free(stack_ptr);
 bf8:	8526                	mv	a0,s1
 bfa:	00000097          	auipc	ra,0x0
 bfe:	c9c080e7          	jalr	-868(ra) # 896 <free>
    stacks[num_threads] = 0;
 c02:	00000717          	auipc	a4,0x0
 c06:	42e72703          	lw	a4,1070(a4) # 1030 <num_threads>
 c0a:	070e                	slli	a4,a4,0x3
 c0c:	00000797          	auipc	a5,0x0
 c10:	41c7b783          	ld	a5,1052(a5) # 1028 <stacks>
 c14:	97ba                	add	a5,a5,a4
 c16:	0007b023          	sd	zero,0(a5)
 c1a:	64e2                	ld	s1,24(sp)
 c1c:	bf61                	j	bb4 <ithread_create+0x90>

0000000000000c1e <ithread_join>:

int ithread_join(int thread_id) {
 c1e:	1101                	addi	sp,sp,-32
 c20:	ec06                	sd	ra,24(sp)
 c22:	e822                	sd	s0,16(sp)
 c24:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 c26:	ff040793          	addi	a5,s0,-16
 c2a:	ffc7859b          	addiw	a1,a5,-4
 c2e:	00000097          	auipc	ra,0x0
 c32:	90c080e7          	jalr	-1780(ra) # 53a <join_thread>
  threads_done++;
 c36:	00000717          	auipc	a4,0x0
 c3a:	3fe70713          	addi	a4,a4,1022 # 1034 <threads_done>
 c3e:	431c                	lw	a5,0(a4)
 c40:	2785                	addiw	a5,a5,1
 c42:	0007869b          	sext.w	a3,a5
 c46:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 c48:	00000797          	auipc	a5,0x0
 c4c:	3e87a783          	lw	a5,1000(a5) # 1030 <num_threads>
 c50:	00d78863          	beq	a5,a3,c60 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 c54:	fec42503          	lw	a0,-20(s0)
 c58:	60e2                	ld	ra,24(sp)
 c5a:	6442                	ld	s0,16(sp)
 c5c:	6105                	addi	sp,sp,32
 c5e:	8082                	ret
    free_stacks();
 c60:	00000097          	auipc	ra,0x0
 c64:	dd2080e7          	jalr	-558(ra) # a32 <free_stacks>
 c68:	b7f5                	j	c54 <ithread_join+0x36>
