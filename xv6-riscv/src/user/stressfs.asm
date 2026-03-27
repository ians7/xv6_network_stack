
src/user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	b9a78793          	addi	a5,a5,-1126 # bb0 <ithread_join+0x8a>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	b5450513          	addi	a0,a0,-1196 # b80 <ithread_join+0x5a>
  34:	00000097          	auipc	ra,0x0
  38:	734080e7          	jalr	1844(ra) # 768 <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	addi	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	150080e7          	jalr	336(ra) # 198 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	336080e7          	jalr	822(ra) # 38a <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addiw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	b3050513          	addi	a0,a0,-1232 # b98 <ithread_join+0x72>
  70:	00000097          	auipc	ra,0x0
  74:	6f8080e7          	jalr	1784(ra) # 768 <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9fa5                	addw	a5,a5,s1
  7e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	348080e7          	jalr	840(ra) # 3d2 <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	addi	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	312080e7          	jalr	786(ra) # 3b2 <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addiw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	30c080e7          	jalr	780(ra) # 3ba <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	af250513          	addi	a0,a0,-1294 # ba8 <ithread_join+0x82>
  be:	00000097          	auipc	ra,0x0
  c2:	6aa080e7          	jalr	1706(ra) # 768 <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	addi	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	306080e7          	jalr	774(ra) # 3d2 <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	addi	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	2c8080e7          	jalr	712(ra) # 3aa <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addiw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	2ca080e7          	jalr	714(ra) # 3ba <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2a0080e7          	jalr	672(ra) # 39a <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	28e080e7          	jalr	654(ra) # 392 <exit>

000000000000010c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  extern int main();
  main();
 114:	00000097          	auipc	ra,0x0
 118:	eec080e7          	jalr	-276(ra) # 0 <main>
  exit(0);
 11c:	4501                	li	a0,0
 11e:	00000097          	auipc	ra,0x0
 122:	274080e7          	jalr	628(ra) # 392 <exit>

0000000000000126 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12c:	87aa                	mv	a5,a0
 12e:	0585                	addi	a1,a1,1
 130:	0785                	addi	a5,a5,1
 132:	fff5c703          	lbu	a4,-1(a1)
 136:	fee78fa3          	sb	a4,-1(a5)
 13a:	fb75                	bnez	a4,12e <strcpy+0x8>
    ;
  return os;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 142:	1141                	addi	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb91                	beqz	a5,160 <strcmp+0x1e>
 14e:	0005c703          	lbu	a4,0(a1)
 152:	00f71763          	bne	a4,a5,160 <strcmp+0x1e>
    p++, q++;
 156:	0505                	addi	a0,a0,1
 158:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	fbe5                	bnez	a5,14e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 160:	0005c503          	lbu	a0,0(a1)
}
 164:	40a7853b          	subw	a0,a5,a0
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strlen>:

uint
strlen(const char *s)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 174:	00054783          	lbu	a5,0(a0)
 178:	cf91                	beqz	a5,194 <strlen+0x26>
 17a:	0505                	addi	a0,a0,1
 17c:	87aa                	mv	a5,a0
 17e:	86be                	mv	a3,a5
 180:	0785                	addi	a5,a5,1
 182:	fff7c703          	lbu	a4,-1(a5)
 186:	ff65                	bnez	a4,17e <strlen+0x10>
 188:	40a6853b          	subw	a0,a3,a0
 18c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 18e:	6422                	ld	s0,8(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret
  for(n = 0; s[n]; n++)
 194:	4501                	li	a0,0
 196:	bfe5                	j	18e <strlen+0x20>

0000000000000198 <memset>:

void*
memset(void *dst, int c, uint n)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19e:	ca19                	beqz	a2,1b4 <memset+0x1c>
 1a0:	87aa                	mv	a5,a0
 1a2:	1602                	slli	a2,a2,0x20
 1a4:	9201                	srli	a2,a2,0x20
 1a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ae:	0785                	addi	a5,a5,1
 1b0:	fee79de3          	bne	a5,a4,1aa <memset+0x12>
  }
  return dst;
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	addi	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strchr>:

char*
strchr(const char *s, char c)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cb99                	beqz	a5,1da <strchr+0x20>
    if(*s == c)
 1c6:	00f58763          	beq	a1,a5,1d4 <strchr+0x1a>
  for(; *s; s++)
 1ca:	0505                	addi	a0,a0,1
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	fbfd                	bnez	a5,1c6 <strchr+0xc>
      return (char*)s;
  return 0;
 1d2:	4501                	li	a0,0
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfe5                	j	1d4 <strchr+0x1a>

00000000000001de <gets>:

char*
gets(char *buf, int max)
{
 1de:	711d                	addi	sp,sp,-96
 1e0:	ec86                	sd	ra,88(sp)
 1e2:	e8a2                	sd	s0,80(sp)
 1e4:	e4a6                	sd	s1,72(sp)
 1e6:	e0ca                	sd	s2,64(sp)
 1e8:	fc4e                	sd	s3,56(sp)
 1ea:	f852                	sd	s4,48(sp)
 1ec:	f456                	sd	s5,40(sp)
 1ee:	f05a                	sd	s6,32(sp)
 1f0:	ec5e                	sd	s7,24(sp)
 1f2:	1080                	addi	s0,sp,96
 1f4:	8baa                	mv	s7,a0
 1f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f8:	892a                	mv	s2,a0
 1fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1fc:	4aa9                	li	s5,10
 1fe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 200:	89a6                	mv	s3,s1
 202:	2485                	addiw	s1,s1,1
 204:	0344d863          	bge	s1,s4,234 <gets+0x56>
    cc = read(0, &c, 1);
 208:	4605                	li	a2,1
 20a:	faf40593          	addi	a1,s0,-81
 20e:	4501                	li	a0,0
 210:	00000097          	auipc	ra,0x0
 214:	19a080e7          	jalr	410(ra) # 3aa <read>
    if(cc < 1)
 218:	00a05e63          	blez	a0,234 <gets+0x56>
    buf[i++] = c;
 21c:	faf44783          	lbu	a5,-81(s0)
 220:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 224:	01578763          	beq	a5,s5,232 <gets+0x54>
 228:	0905                	addi	s2,s2,1
 22a:	fd679be3          	bne	a5,s6,200 <gets+0x22>
    buf[i++] = c;
 22e:	89a6                	mv	s3,s1
 230:	a011                	j	234 <gets+0x56>
 232:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 234:	99de                	add	s3,s3,s7
 236:	00098023          	sb	zero,0(s3)
  return buf;
}
 23a:	855e                	mv	a0,s7
 23c:	60e6                	ld	ra,88(sp)
 23e:	6446                	ld	s0,80(sp)
 240:	64a6                	ld	s1,72(sp)
 242:	6906                	ld	s2,64(sp)
 244:	79e2                	ld	s3,56(sp)
 246:	7a42                	ld	s4,48(sp)
 248:	7aa2                	ld	s5,40(sp)
 24a:	7b02                	ld	s6,32(sp)
 24c:	6be2                	ld	s7,24(sp)
 24e:	6125                	addi	sp,sp,96
 250:	8082                	ret

0000000000000252 <stat>:

int
stat(const char *n, struct stat *st)
{
 252:	1101                	addi	sp,sp,-32
 254:	ec06                	sd	ra,24(sp)
 256:	e822                	sd	s0,16(sp)
 258:	e04a                	sd	s2,0(sp)
 25a:	1000                	addi	s0,sp,32
 25c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25e:	4581                	li	a1,0
 260:	00000097          	auipc	ra,0x0
 264:	172080e7          	jalr	370(ra) # 3d2 <open>
  if(fd < 0)
 268:	02054663          	bltz	a0,294 <stat+0x42>
 26c:	e426                	sd	s1,8(sp)
 26e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	00000097          	auipc	ra,0x0
 276:	178080e7          	jalr	376(ra) # 3ea <fstat>
 27a:	892a                	mv	s2,a0
  close(fd);
 27c:	8526                	mv	a0,s1
 27e:	00000097          	auipc	ra,0x0
 282:	13c080e7          	jalr	316(ra) # 3ba <close>
  return r;
 286:	64a2                	ld	s1,8(sp)
}
 288:	854a                	mv	a0,s2
 28a:	60e2                	ld	ra,24(sp)
 28c:	6442                	ld	s0,16(sp)
 28e:	6902                	ld	s2,0(sp)
 290:	6105                	addi	sp,sp,32
 292:	8082                	ret
    return -1;
 294:	597d                	li	s2,-1
 296:	bfcd                	j	288 <stat+0x36>

0000000000000298 <atoi>:

int
atoi(const char *s)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29e:	00054683          	lbu	a3,0(a0)
 2a2:	fd06879b          	addiw	a5,a3,-48
 2a6:	0ff7f793          	zext.b	a5,a5
 2aa:	4625                	li	a2,9
 2ac:	02f66863          	bltu	a2,a5,2dc <atoi+0x44>
 2b0:	872a                	mv	a4,a0
  n = 0;
 2b2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b4:	0705                	addi	a4,a4,1
 2b6:	0025179b          	slliw	a5,a0,0x2
 2ba:	9fa9                	addw	a5,a5,a0
 2bc:	0017979b          	slliw	a5,a5,0x1
 2c0:	9fb5                	addw	a5,a5,a3
 2c2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c6:	00074683          	lbu	a3,0(a4)
 2ca:	fd06879b          	addiw	a5,a3,-48
 2ce:	0ff7f793          	zext.b	a5,a5
 2d2:	fef671e3          	bgeu	a2,a5,2b4 <atoi+0x1c>
  return n;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret
  n = 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <atoi+0x3e>

00000000000002e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e6:	02b57463          	bgeu	a0,a1,30e <memmove+0x2e>
    while(n-- > 0)
 2ea:	00c05f63          	blez	a2,308 <memmove+0x28>
 2ee:	1602                	slli	a2,a2,0x20
 2f0:	9201                	srli	a2,a2,0x20
 2f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f8:	0585                	addi	a1,a1,1
 2fa:	0705                	addi	a4,a4,1
 2fc:	fff5c683          	lbu	a3,-1(a1)
 300:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 304:	fef71ae3          	bne	a4,a5,2f8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
    dst += n;
 30e:	00c50733          	add	a4,a0,a2
    src += n;
 312:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 314:	fec05ae3          	blez	a2,308 <memmove+0x28>
 318:	fff6079b          	addiw	a5,a2,-1
 31c:	1782                	slli	a5,a5,0x20
 31e:	9381                	srli	a5,a5,0x20
 320:	fff7c793          	not	a5,a5
 324:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 326:	15fd                	addi	a1,a1,-1
 328:	177d                	addi	a4,a4,-1
 32a:	0005c683          	lbu	a3,0(a1)
 32e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 332:	fee79ae3          	bne	a5,a4,326 <memmove+0x46>
 336:	bfc9                	j	308 <memmove+0x28>

0000000000000338 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e422                	sd	s0,8(sp)
 33c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33e:	ca05                	beqz	a2,36e <memcmp+0x36>
 340:	fff6069b          	addiw	a3,a2,-1
 344:	1682                	slli	a3,a3,0x20
 346:	9281                	srli	a3,a3,0x20
 348:	0685                	addi	a3,a3,1
 34a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34c:	00054783          	lbu	a5,0(a0)
 350:	0005c703          	lbu	a4,0(a1)
 354:	00e79863          	bne	a5,a4,364 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 358:	0505                	addi	a0,a0,1
    p2++;
 35a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35c:	fed518e3          	bne	a0,a3,34c <memcmp+0x14>
  }
  return 0;
 360:	4501                	li	a0,0
 362:	a019                	j	368 <memcmp+0x30>
      return *p1 - *p2;
 364:	40e7853b          	subw	a0,a5,a4
}
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret
  return 0;
 36e:	4501                	li	a0,0
 370:	bfe5                	j	368 <memcmp+0x30>

0000000000000372 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 372:	1141                	addi	sp,sp,-16
 374:	e406                	sd	ra,8(sp)
 376:	e022                	sd	s0,0(sp)
 378:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 37a:	00000097          	auipc	ra,0x0
 37e:	f66080e7          	jalr	-154(ra) # 2e0 <memmove>
}
 382:	60a2                	ld	ra,8(sp)
 384:	6402                	ld	s0,0(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38a:	4885                	li	a7,1
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <exit>:
.global exit
exit:
 li a7, SYS_exit
 392:	4889                	li	a7,2
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <wait>:
.global wait
wait:
 li a7, SYS_wait
 39a:	488d                	li	a7,3
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a2:	4891                	li	a7,4
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <read>:
.global read
read:
 li a7, SYS_read
 3aa:	4895                	li	a7,5
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <write>:
.global write
write:
 li a7, SYS_write
 3b2:	48c1                	li	a7,16
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <close>:
.global close
close:
 li a7, SYS_close
 3ba:	48d5                	li	a7,21
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c2:	4899                	li	a7,6
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ca:	489d                	li	a7,7
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <open>:
.global open
open:
 li a7, SYS_open
 3d2:	48bd                	li	a7,15
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3da:	48c5                	li	a7,17
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e2:	48c9                	li	a7,18
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ea:	48a1                	li	a7,8
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <link>:
.global link
link:
 li a7, SYS_link
 3f2:	48cd                	li	a7,19
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fa:	48d1                	li	a7,20
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 402:	48a5                	li	a7,9
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <dup>:
.global dup
dup:
 li a7, SYS_dup
 40a:	48a9                	li	a7,10
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 412:	48ad                	li	a7,11
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 41a:	48b1                	li	a7,12
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 422:	48b5                	li	a7,13
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42a:	48b9                	li	a7,14
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 432:	48d9                	li	a7,22
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 43a:	48dd                	li	a7,23
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 442:	48e1                	li	a7,24
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 44a:	48e5                	li	a7,25
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <socket>:
.global socket
socket:
 li a7, SYS_socket
 452:	48e9                	li	a7,26
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <bind>:
.global bind
bind:
 li a7, SYS_bind
 45a:	48ed                	li	a7,27
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <accept>:
.global accept
accept:
 li a7, SYS_accept
 462:	48f5                	li	a7,29
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <listen>:
.global listen
listen:
 li a7, SYS_listen
 46a:	48f1                	li	a7,28
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <connect>:
.global connect
connect:
 li a7, SYS_connect
 472:	48f9                	li	a7,30
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <send>:
.global send
send:
 li a7, SYS_send
 47a:	48fd                	li	a7,31
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <recv>:
.global recv
recv:
 li a7, SYS_recv
 482:	02000893          	li	a7,32
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 48c:	02100893          	li	a7,33
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 496:	02200893          	li	a7,34
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a0:	1101                	addi	sp,sp,-32
 4a2:	ec06                	sd	ra,24(sp)
 4a4:	e822                	sd	s0,16(sp)
 4a6:	1000                	addi	s0,sp,32
 4a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ac:	4605                	li	a2,1
 4ae:	fef40593          	addi	a1,s0,-17
 4b2:	00000097          	auipc	ra,0x0
 4b6:	f00080e7          	jalr	-256(ra) # 3b2 <write>
}
 4ba:	60e2                	ld	ra,24(sp)
 4bc:	6442                	ld	s0,16(sp)
 4be:	6105                	addi	sp,sp,32
 4c0:	8082                	ret

00000000000004c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c2:	7139                	addi	sp,sp,-64
 4c4:	fc06                	sd	ra,56(sp)
 4c6:	f822                	sd	s0,48(sp)
 4c8:	f426                	sd	s1,40(sp)
 4ca:	0080                	addi	s0,sp,64
 4cc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ce:	c299                	beqz	a3,4d4 <printint+0x12>
 4d0:	0805cb63          	bltz	a1,566 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d4:	2581                	sext.w	a1,a1
  neg = 0;
 4d6:	4881                	li	a7,0
 4d8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4dc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4de:	2601                	sext.w	a2,a2
 4e0:	00000517          	auipc	a0,0x0
 4e4:	77050513          	addi	a0,a0,1904 # c50 <digits>
 4e8:	883a                	mv	a6,a4
 4ea:	2705                	addiw	a4,a4,1
 4ec:	02c5f7bb          	remuw	a5,a1,a2
 4f0:	1782                	slli	a5,a5,0x20
 4f2:	9381                	srli	a5,a5,0x20
 4f4:	97aa                	add	a5,a5,a0
 4f6:	0007c783          	lbu	a5,0(a5)
 4fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4fe:	0005879b          	sext.w	a5,a1
 502:	02c5d5bb          	divuw	a1,a1,a2
 506:	0685                	addi	a3,a3,1
 508:	fec7f0e3          	bgeu	a5,a2,4e8 <printint+0x26>
  if(neg)
 50c:	00088c63          	beqz	a7,524 <printint+0x62>
    buf[i++] = '-';
 510:	fd070793          	addi	a5,a4,-48
 514:	00878733          	add	a4,a5,s0
 518:	02d00793          	li	a5,45
 51c:	fef70823          	sb	a5,-16(a4)
 520:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 524:	02e05c63          	blez	a4,55c <printint+0x9a>
 528:	f04a                	sd	s2,32(sp)
 52a:	ec4e                	sd	s3,24(sp)
 52c:	fc040793          	addi	a5,s0,-64
 530:	00e78933          	add	s2,a5,a4
 534:	fff78993          	addi	s3,a5,-1
 538:	99ba                	add	s3,s3,a4
 53a:	377d                	addiw	a4,a4,-1
 53c:	1702                	slli	a4,a4,0x20
 53e:	9301                	srli	a4,a4,0x20
 540:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 544:	fff94583          	lbu	a1,-1(s2)
 548:	8526                	mv	a0,s1
 54a:	00000097          	auipc	ra,0x0
 54e:	f56080e7          	jalr	-170(ra) # 4a0 <putc>
  while(--i >= 0)
 552:	197d                	addi	s2,s2,-1
 554:	ff3918e3          	bne	s2,s3,544 <printint+0x82>
 558:	7902                	ld	s2,32(sp)
 55a:	69e2                	ld	s3,24(sp)
}
 55c:	70e2                	ld	ra,56(sp)
 55e:	7442                	ld	s0,48(sp)
 560:	74a2                	ld	s1,40(sp)
 562:	6121                	addi	sp,sp,64
 564:	8082                	ret
    x = -xx;
 566:	40b005bb          	negw	a1,a1
    neg = 1;
 56a:	4885                	li	a7,1
    x = -xx;
 56c:	b7b5                	j	4d8 <printint+0x16>

000000000000056e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 56e:	715d                	addi	sp,sp,-80
 570:	e486                	sd	ra,72(sp)
 572:	e0a2                	sd	s0,64(sp)
 574:	f84a                	sd	s2,48(sp)
 576:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 578:	0005c903          	lbu	s2,0(a1)
 57c:	1a090a63          	beqz	s2,730 <vprintf+0x1c2>
 580:	fc26                	sd	s1,56(sp)
 582:	f44e                	sd	s3,40(sp)
 584:	f052                	sd	s4,32(sp)
 586:	ec56                	sd	s5,24(sp)
 588:	e85a                	sd	s6,16(sp)
 58a:	e45e                	sd	s7,8(sp)
 58c:	8aaa                	mv	s5,a0
 58e:	8bb2                	mv	s7,a2
 590:	00158493          	addi	s1,a1,1
  state = 0;
 594:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 596:	02500a13          	li	s4,37
 59a:	4b55                	li	s6,21
 59c:	a839                	j	5ba <vprintf+0x4c>
        putc(fd, c);
 59e:	85ca                	mv	a1,s2
 5a0:	8556                	mv	a0,s5
 5a2:	00000097          	auipc	ra,0x0
 5a6:	efe080e7          	jalr	-258(ra) # 4a0 <putc>
 5aa:	a019                	j	5b0 <vprintf+0x42>
    } else if(state == '%'){
 5ac:	01498d63          	beq	s3,s4,5c6 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5b0:	0485                	addi	s1,s1,1
 5b2:	fff4c903          	lbu	s2,-1(s1)
 5b6:	16090763          	beqz	s2,724 <vprintf+0x1b6>
    if(state == 0){
 5ba:	fe0999e3          	bnez	s3,5ac <vprintf+0x3e>
      if(c == '%'){
 5be:	ff4910e3          	bne	s2,s4,59e <vprintf+0x30>
        state = '%';
 5c2:	89d2                	mv	s3,s4
 5c4:	b7f5                	j	5b0 <vprintf+0x42>
      if(c == 'd'){
 5c6:	13490463          	beq	s2,s4,6ee <vprintf+0x180>
 5ca:	f9d9079b          	addiw	a5,s2,-99
 5ce:	0ff7f793          	zext.b	a5,a5
 5d2:	12fb6763          	bltu	s6,a5,700 <vprintf+0x192>
 5d6:	f9d9079b          	addiw	a5,s2,-99
 5da:	0ff7f713          	zext.b	a4,a5
 5de:	12eb6163          	bltu	s6,a4,700 <vprintf+0x192>
 5e2:	00271793          	slli	a5,a4,0x2
 5e6:	00000717          	auipc	a4,0x0
 5ea:	61270713          	addi	a4,a4,1554 # bf8 <ithread_join+0xd2>
 5ee:	97ba                	add	a5,a5,a4
 5f0:	439c                	lw	a5,0(a5)
 5f2:	97ba                	add	a5,a5,a4
 5f4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	4685                	li	a3,1
 5fc:	4629                	li	a2,10
 5fe:	000ba583          	lw	a1,0(s7)
 602:	8556                	mv	a0,s5
 604:	00000097          	auipc	ra,0x0
 608:	ebe080e7          	jalr	-322(ra) # 4c2 <printint>
 60c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 60e:	4981                	li	s3,0
 610:	b745                	j	5b0 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 612:	008b8913          	addi	s2,s7,8
 616:	4681                	li	a3,0
 618:	4629                	li	a2,10
 61a:	000ba583          	lw	a1,0(s7)
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	ea2080e7          	jalr	-350(ra) # 4c2 <printint>
 628:	8bca                	mv	s7,s2
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b751                	j	5b0 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 62e:	008b8913          	addi	s2,s7,8
 632:	4681                	li	a3,0
 634:	4641                	li	a2,16
 636:	000ba583          	lw	a1,0(s7)
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	e86080e7          	jalr	-378(ra) # 4c2 <printint>
 644:	8bca                	mv	s7,s2
      state = 0;
 646:	4981                	li	s3,0
 648:	b7a5                	j	5b0 <vprintf+0x42>
 64a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 64c:	008b8c13          	addi	s8,s7,8
 650:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 654:	03000593          	li	a1,48
 658:	8556                	mv	a0,s5
 65a:	00000097          	auipc	ra,0x0
 65e:	e46080e7          	jalr	-442(ra) # 4a0 <putc>
  putc(fd, 'x');
 662:	07800593          	li	a1,120
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e38080e7          	jalr	-456(ra) # 4a0 <putc>
 670:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 672:	00000b97          	auipc	s7,0x0
 676:	5deb8b93          	addi	s7,s7,1502 # c50 <digits>
 67a:	03c9d793          	srli	a5,s3,0x3c
 67e:	97de                	add	a5,a5,s7
 680:	0007c583          	lbu	a1,0(a5)
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	e1a080e7          	jalr	-486(ra) # 4a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 68e:	0992                	slli	s3,s3,0x4
 690:	397d                	addiw	s2,s2,-1
 692:	fe0914e3          	bnez	s2,67a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 696:	8be2                	mv	s7,s8
      state = 0;
 698:	4981                	li	s3,0
 69a:	6c02                	ld	s8,0(sp)
 69c:	bf11                	j	5b0 <vprintf+0x42>
        s = va_arg(ap, char*);
 69e:	008b8993          	addi	s3,s7,8
 6a2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6a6:	02090163          	beqz	s2,6c8 <vprintf+0x15a>
        while(*s != 0){
 6aa:	00094583          	lbu	a1,0(s2)
 6ae:	c9a5                	beqz	a1,71e <vprintf+0x1b0>
          putc(fd, *s);
 6b0:	8556                	mv	a0,s5
 6b2:	00000097          	auipc	ra,0x0
 6b6:	dee080e7          	jalr	-530(ra) # 4a0 <putc>
          s++;
 6ba:	0905                	addi	s2,s2,1
        while(*s != 0){
 6bc:	00094583          	lbu	a1,0(s2)
 6c0:	f9e5                	bnez	a1,6b0 <vprintf+0x142>
        s = va_arg(ap, char*);
 6c2:	8bce                	mv	s7,s3
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	b5ed                	j	5b0 <vprintf+0x42>
          s = "(null)";
 6c8:	00000917          	auipc	s2,0x0
 6cc:	4f890913          	addi	s2,s2,1272 # bc0 <ithread_join+0x9a>
        while(*s != 0){
 6d0:	02800593          	li	a1,40
 6d4:	bff1                	j	6b0 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6d6:	008b8913          	addi	s2,s7,8
 6da:	000bc583          	lbu	a1,0(s7)
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	dc0080e7          	jalr	-576(ra) # 4a0 <putc>
 6e8:	8bca                	mv	s7,s2
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	b5d1                	j	5b0 <vprintf+0x42>
        putc(fd, c);
 6ee:	02500593          	li	a1,37
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	dac080e7          	jalr	-596(ra) # 4a0 <putc>
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bd4d                	j	5b0 <vprintf+0x42>
        putc(fd, '%');
 700:	02500593          	li	a1,37
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	d9a080e7          	jalr	-614(ra) # 4a0 <putc>
        putc(fd, c);
 70e:	85ca                	mv	a1,s2
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	d8e080e7          	jalr	-626(ra) # 4a0 <putc>
      state = 0;
 71a:	4981                	li	s3,0
 71c:	bd51                	j	5b0 <vprintf+0x42>
        s = va_arg(ap, char*);
 71e:	8bce                	mv	s7,s3
      state = 0;
 720:	4981                	li	s3,0
 722:	b579                	j	5b0 <vprintf+0x42>
 724:	74e2                	ld	s1,56(sp)
 726:	79a2                	ld	s3,40(sp)
 728:	7a02                	ld	s4,32(sp)
 72a:	6ae2                	ld	s5,24(sp)
 72c:	6b42                	ld	s6,16(sp)
 72e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 730:	60a6                	ld	ra,72(sp)
 732:	6406                	ld	s0,64(sp)
 734:	7942                	ld	s2,48(sp)
 736:	6161                	addi	sp,sp,80
 738:	8082                	ret

000000000000073a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 73a:	715d                	addi	sp,sp,-80
 73c:	ec06                	sd	ra,24(sp)
 73e:	e822                	sd	s0,16(sp)
 740:	1000                	addi	s0,sp,32
 742:	e010                	sd	a2,0(s0)
 744:	e414                	sd	a3,8(s0)
 746:	e818                	sd	a4,16(s0)
 748:	ec1c                	sd	a5,24(s0)
 74a:	03043023          	sd	a6,32(s0)
 74e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 756:	8622                	mv	a2,s0
 758:	00000097          	auipc	ra,0x0
 75c:	e16080e7          	jalr	-490(ra) # 56e <vprintf>
}
 760:	60e2                	ld	ra,24(sp)
 762:	6442                	ld	s0,16(sp)
 764:	6161                	addi	sp,sp,80
 766:	8082                	ret

0000000000000768 <printf>:

void
printf(const char *fmt, ...)
{
 768:	711d                	addi	sp,sp,-96
 76a:	ec06                	sd	ra,24(sp)
 76c:	e822                	sd	s0,16(sp)
 76e:	1000                	addi	s0,sp,32
 770:	e40c                	sd	a1,8(s0)
 772:	e810                	sd	a2,16(s0)
 774:	ec14                	sd	a3,24(s0)
 776:	f018                	sd	a4,32(s0)
 778:	f41c                	sd	a5,40(s0)
 77a:	03043823          	sd	a6,48(s0)
 77e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 782:	00840613          	addi	a2,s0,8
 786:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 78a:	85aa                	mv	a1,a0
 78c:	4505                	li	a0,1
 78e:	00000097          	auipc	ra,0x0
 792:	de0080e7          	jalr	-544(ra) # 56e <vprintf>
}
 796:	60e2                	ld	ra,24(sp)
 798:	6442                	ld	s0,16(sp)
 79a:	6125                	addi	sp,sp,96
 79c:	8082                	ret

000000000000079e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79e:	1141                	addi	sp,sp,-16
 7a0:	e422                	sd	s0,8(sp)
 7a2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	00001797          	auipc	a5,0x1
 7ac:	8687b783          	ld	a5,-1944(a5) # 1010 <freep>
 7b0:	a02d                	j	7da <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7b2:	4618                	lw	a4,8(a2)
 7b4:	9f2d                	addw	a4,a4,a1
 7b6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ba:	6398                	ld	a4,0(a5)
 7bc:	6310                	ld	a2,0(a4)
 7be:	a83d                	j	7fc <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7c0:	ff852703          	lw	a4,-8(a0)
 7c4:	9f31                	addw	a4,a4,a2
 7c6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7c8:	ff053683          	ld	a3,-16(a0)
 7cc:	a091                	j	810 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ce:	6398                	ld	a4,0(a5)
 7d0:	00e7e463          	bltu	a5,a4,7d8 <free+0x3a>
 7d4:	00e6ea63          	bltu	a3,a4,7e8 <free+0x4a>
{
 7d8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7da:	fed7fae3          	bgeu	a5,a3,7ce <free+0x30>
 7de:	6398                	ld	a4,0(a5)
 7e0:	00e6e463          	bltu	a3,a4,7e8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e4:	fee7eae3          	bltu	a5,a4,7d8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7e8:	ff852583          	lw	a1,-8(a0)
 7ec:	6390                	ld	a2,0(a5)
 7ee:	02059813          	slli	a6,a1,0x20
 7f2:	01c85713          	srli	a4,a6,0x1c
 7f6:	9736                	add	a4,a4,a3
 7f8:	fae60de3          	beq	a2,a4,7b2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7fc:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 800:	4790                	lw	a2,8(a5)
 802:	02061593          	slli	a1,a2,0x20
 806:	01c5d713          	srli	a4,a1,0x1c
 80a:	973e                	add	a4,a4,a5
 80c:	fae68ae3          	beq	a3,a4,7c0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 810:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 812:	00000717          	auipc	a4,0x0
 816:	7ef73f23          	sd	a5,2046(a4) # 1010 <freep>
}
 81a:	6422                	ld	s0,8(sp)
 81c:	0141                	addi	sp,sp,16
 81e:	8082                	ret

0000000000000820 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 820:	7139                	addi	sp,sp,-64
 822:	fc06                	sd	ra,56(sp)
 824:	f822                	sd	s0,48(sp)
 826:	f426                	sd	s1,40(sp)
 828:	ec4e                	sd	s3,24(sp)
 82a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82c:	02051493          	slli	s1,a0,0x20
 830:	9081                	srli	s1,s1,0x20
 832:	04bd                	addi	s1,s1,15
 834:	8091                	srli	s1,s1,0x4
 836:	0014899b          	addiw	s3,s1,1
 83a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 83c:	00000517          	auipc	a0,0x0
 840:	7d453503          	ld	a0,2004(a0) # 1010 <freep>
 844:	c915                	beqz	a0,878 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 846:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 848:	4798                	lw	a4,8(a5)
 84a:	08977e63          	bgeu	a4,s1,8e6 <malloc+0xc6>
 84e:	f04a                	sd	s2,32(sp)
 850:	e852                	sd	s4,16(sp)
 852:	e456                	sd	s5,8(sp)
 854:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 856:	8a4e                	mv	s4,s3
 858:	0009871b          	sext.w	a4,s3
 85c:	6685                	lui	a3,0x1
 85e:	00d77363          	bgeu	a4,a3,864 <malloc+0x44>
 862:	6a05                	lui	s4,0x1
 864:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 868:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 86c:	00000917          	auipc	s2,0x0
 870:	7a490913          	addi	s2,s2,1956 # 1010 <freep>
  if(p == (char*)-1)
 874:	5afd                	li	s5,-1
 876:	a091                	j	8ba <malloc+0x9a>
 878:	f04a                	sd	s2,32(sp)
 87a:	e852                	sd	s4,16(sp)
 87c:	e456                	sd	s5,8(sp)
 87e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 880:	00000797          	auipc	a5,0x0
 884:	7b078793          	addi	a5,a5,1968 # 1030 <base>
 888:	00000717          	auipc	a4,0x0
 88c:	78f73423          	sd	a5,1928(a4) # 1010 <freep>
 890:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 892:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 896:	b7c1                	j	856 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 898:	6398                	ld	a4,0(a5)
 89a:	e118                	sd	a4,0(a0)
 89c:	a08d                	j	8fe <malloc+0xde>
  hp->s.size = nu;
 89e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8a2:	0541                	addi	a0,a0,16
 8a4:	00000097          	auipc	ra,0x0
 8a8:	efa080e7          	jalr	-262(ra) # 79e <free>
  return freep;
 8ac:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8b0:	c13d                	beqz	a0,916 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b4:	4798                	lw	a4,8(a5)
 8b6:	02977463          	bgeu	a4,s1,8de <malloc+0xbe>
    if(p == freep)
 8ba:	00093703          	ld	a4,0(s2)
 8be:	853e                	mv	a0,a5
 8c0:	fef719e3          	bne	a4,a5,8b2 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 8c4:	8552                	mv	a0,s4
 8c6:	00000097          	auipc	ra,0x0
 8ca:	b54080e7          	jalr	-1196(ra) # 41a <sbrk>
  if(p == (char*)-1)
 8ce:	fd5518e3          	bne	a0,s5,89e <malloc+0x7e>
        return 0;
 8d2:	4501                	li	a0,0
 8d4:	7902                	ld	s2,32(sp)
 8d6:	6a42                	ld	s4,16(sp)
 8d8:	6aa2                	ld	s5,8(sp)
 8da:	6b02                	ld	s6,0(sp)
 8dc:	a03d                	j	90a <malloc+0xea>
 8de:	7902                	ld	s2,32(sp)
 8e0:	6a42                	ld	s4,16(sp)
 8e2:	6aa2                	ld	s5,8(sp)
 8e4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8e6:	fae489e3          	beq	s1,a4,898 <malloc+0x78>
        p->s.size -= nunits;
 8ea:	4137073b          	subw	a4,a4,s3
 8ee:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f0:	02071693          	slli	a3,a4,0x20
 8f4:	01c6d713          	srli	a4,a3,0x1c
 8f8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8fa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8fe:	00000717          	auipc	a4,0x0
 902:	70a73923          	sd	a0,1810(a4) # 1010 <freep>
      return (void*)(p + 1);
 906:	01078513          	addi	a0,a5,16
  }
}
 90a:	70e2                	ld	ra,56(sp)
 90c:	7442                	ld	s0,48(sp)
 90e:	74a2                	ld	s1,40(sp)
 910:	69e2                	ld	s3,24(sp)
 912:	6121                	addi	sp,sp,64
 914:	8082                	ret
 916:	7902                	ld	s2,32(sp)
 918:	6a42                	ld	s4,16(sp)
 91a:	6aa2                	ld	s5,8(sp)
 91c:	6b02                	ld	s6,0(sp)
 91e:	b7f5                	j	90a <malloc+0xea>

0000000000000920 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 920:	1141                	addi	sp,sp,-16
 922:	e406                	sd	ra,8(sp)
 924:	e022                	sd	s0,0(sp)
 926:	0800                	addi	s0,sp,16
  thread_exit(status);
 928:	2501                	sext.w	a0,a0
 92a:	00000097          	auipc	ra,0x0
 92e:	b20080e7          	jalr	-1248(ra) # 44a <thread_exit>
}
 932:	60a2                	ld	ra,8(sp)
 934:	6402                	ld	s0,0(sp)
 936:	0141                	addi	sp,sp,16
 938:	8082                	ret

000000000000093a <free_stacks>:
int free_stacks() {
 93a:	7179                	addi	sp,sp,-48
 93c:	f406                	sd	ra,40(sp)
 93e:	f022                	sd	s0,32(sp)
 940:	ec26                	sd	s1,24(sp)
 942:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 944:	00000797          	auipc	a5,0x0
 948:	6dc7a783          	lw	a5,1756(a5) # 1020 <num_threads>
 94c:	04f05063          	blez	a5,98c <free_stacks+0x52>
 950:	e84a                	sd	s2,16(sp)
 952:	e44e                	sd	s3,8(sp)
 954:	4481                	li	s1,0
    free(stacks[i]);
 956:	00000997          	auipc	s3,0x0
 95a:	6c298993          	addi	s3,s3,1730 # 1018 <stacks>
  for (int i = 0; i < num_threads; i++) {
 95e:	00000917          	auipc	s2,0x0
 962:	6c290913          	addi	s2,s2,1730 # 1020 <num_threads>
    free(stacks[i]);
 966:	0009b783          	ld	a5,0(s3)
 96a:	00349713          	slli	a4,s1,0x3
 96e:	97ba                	add	a5,a5,a4
 970:	6388                	ld	a0,0(a5)
 972:	00000097          	auipc	ra,0x0
 976:	e2c080e7          	jalr	-468(ra) # 79e <free>
  for (int i = 0; i < num_threads; i++) {
 97a:	0485                	addi	s1,s1,1
 97c:	00092703          	lw	a4,0(s2)
 980:	0004879b          	sext.w	a5,s1
 984:	fee7c1e3          	blt	a5,a4,966 <free_stacks+0x2c>
 988:	6942                	ld	s2,16(sp)
 98a:	69a2                	ld	s3,8(sp)
  free(stacks);
 98c:	00000497          	auipc	s1,0x0
 990:	68c48493          	addi	s1,s1,1676 # 1018 <stacks>
 994:	6088                	ld	a0,0(s1)
 996:	00000097          	auipc	ra,0x0
 99a:	e08080e7          	jalr	-504(ra) # 79e <free>
  stacks = 0;
 99e:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 9a2:	00000797          	auipc	a5,0x0
 9a6:	6607af23          	sw	zero,1662(a5) # 1020 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 9aa:	47a1                	li	a5,8
 9ac:	00000717          	auipc	a4,0x0
 9b0:	64f72a23          	sw	a5,1620(a4) # 1000 <max_stacks>
  threads_done = 0;
 9b4:	00000797          	auipc	a5,0x0
 9b8:	6607a823          	sw	zero,1648(a5) # 1024 <threads_done>
}
 9bc:	4501                	li	a0,0
 9be:	70a2                	ld	ra,40(sp)
 9c0:	7402                	ld	s0,32(sp)
 9c2:	64e2                	ld	s1,24(sp)
 9c4:	6145                	addi	sp,sp,48
 9c6:	8082                	ret

00000000000009c8 <expand_num_threads>:
int expand_num_threads() {
 9c8:	1101                	addi	sp,sp,-32
 9ca:	ec06                	sd	ra,24(sp)
 9cc:	e822                	sd	s0,16(sp)
 9ce:	e426                	sd	s1,8(sp)
 9d0:	e04a                	sd	s2,0(sp)
 9d2:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 9d4:	00000797          	auipc	a5,0x0
 9d8:	62c78793          	addi	a5,a5,1580 # 1000 <max_stacks>
 9dc:	4388                	lw	a0,0(a5)
 9de:	0015151b          	slliw	a0,a0,0x1
 9e2:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 9e4:	0035151b          	slliw	a0,a0,0x3
 9e8:	00000097          	auipc	ra,0x0
 9ec:	e38080e7          	jalr	-456(ra) # 820 <malloc>
 9f0:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 9f2:	00000617          	auipc	a2,0x0
 9f6:	62e62603          	lw	a2,1582(a2) # 1020 <num_threads>
 9fa:	00000497          	auipc	s1,0x0
 9fe:	61e48493          	addi	s1,s1,1566 # 1018 <stacks>
 a02:	0036161b          	slliw	a2,a2,0x3
 a06:	608c                	ld	a1,0(s1)
 a08:	00000097          	auipc	ra,0x0
 a0c:	8d8080e7          	jalr	-1832(ra) # 2e0 <memmove>
  free(stacks);
 a10:	6088                	ld	a0,0(s1)
 a12:	00000097          	auipc	ra,0x0
 a16:	d8c080e7          	jalr	-628(ra) # 79e <free>
  stacks = new_stacks;
 a1a:	0124b023          	sd	s2,0(s1)
}
 a1e:	4501                	li	a0,0
 a20:	60e2                	ld	ra,24(sp)
 a22:	6442                	ld	s0,16(sp)
 a24:	64a2                	ld	s1,8(sp)
 a26:	6902                	ld	s2,0(sp)
 a28:	6105                	addi	sp,sp,32
 a2a:	8082                	ret

0000000000000a2c <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a2c:	7179                	addi	sp,sp,-48
 a2e:	f406                	sd	ra,40(sp)
 a30:	f022                	sd	s0,32(sp)
 a32:	e84a                	sd	s2,16(sp)
 a34:	e44e                	sd	s3,8(sp)
 a36:	1800                	addi	s0,sp,48
 a38:	892a                	mv	s2,a0
 a3a:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a3c:	00000797          	auipc	a5,0x0
 a40:	5dc7b783          	ld	a5,1500(a5) # 1018 <stacks>
 a44:	c3d9                	beqz	a5,aca <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a46:	00000797          	auipc	a5,0x0
 a4a:	5ba7a783          	lw	a5,1466(a5) # 1000 <max_stacks>
 a4e:	00000717          	auipc	a4,0x0
 a52:	5d272703          	lw	a4,1490(a4) # 1020 <num_threads>
 a56:	0af71363          	bne	a4,a5,afc <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 a5a:	04000713          	li	a4,64
 a5e:	08e78563          	beq	a5,a4,ae8 <ithread_create+0xbc>
 a62:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a64:	00000097          	auipc	ra,0x0
 a68:	f64080e7          	jalr	-156(ra) # 9c8 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a6c:	6505                	lui	a0,0x1
 a6e:	00000097          	auipc	ra,0x0
 a72:	db2080e7          	jalr	-590(ra) # 820 <malloc>
 a76:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a78:	00000717          	auipc	a4,0x0
 a7c:	5a872703          	lw	a4,1448(a4) # 1020 <num_threads>
 a80:	070e                	slli	a4,a4,0x3
 a82:	00000797          	auipc	a5,0x0
 a86:	5967b783          	ld	a5,1430(a5) # 1018 <stacks>
 a8a:	97ba                	add	a5,a5,a4
 a8c:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 a8e:	00000697          	auipc	a3,0x0
 a92:	e9268693          	addi	a3,a3,-366 # 920 <ithread_exit>
 a96:	862a                	mv	a2,a0
 a98:	85ce                	mv	a1,s3
 a9a:	854a                	mv	a0,s2
 a9c:	00000097          	auipc	ra,0x0
 aa0:	99e080e7          	jalr	-1634(ra) # 43a <create_thread>
 aa4:	892a                	mv	s2,a0
  if (res != -1) {
 aa6:	57fd                	li	a5,-1
 aa8:	04f50c63          	beq	a0,a5,b00 <ithread_create+0xd4>
    num_threads++;
 aac:	00000717          	auipc	a4,0x0
 ab0:	57470713          	addi	a4,a4,1396 # 1020 <num_threads>
 ab4:	431c                	lw	a5,0(a4)
 ab6:	2785                	addiw	a5,a5,1
 ab8:	c31c                	sw	a5,0(a4)
 aba:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 abc:	854a                	mv	a0,s2
 abe:	70a2                	ld	ra,40(sp)
 ac0:	7402                	ld	s0,32(sp)
 ac2:	6942                	ld	s2,16(sp)
 ac4:	69a2                	ld	s3,8(sp)
 ac6:	6145                	addi	sp,sp,48
 ac8:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 aca:	00000517          	auipc	a0,0x0
 ace:	53652503          	lw	a0,1334(a0) # 1000 <max_stacks>
 ad2:	0035151b          	slliw	a0,a0,0x3
 ad6:	00000097          	auipc	ra,0x0
 ada:	d4a080e7          	jalr	-694(ra) # 820 <malloc>
 ade:	00000797          	auipc	a5,0x0
 ae2:	52a7bd23          	sd	a0,1338(a5) # 1018 <stacks>
 ae6:	b785                	j	a46 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 ae8:	00000517          	auipc	a0,0x0
 aec:	0e050513          	addi	a0,a0,224 # bc8 <ithread_join+0xa2>
 af0:	00000097          	auipc	ra,0x0
 af4:	c78080e7          	jalr	-904(ra) # 768 <printf>
      return -1;
 af8:	597d                	li	s2,-1
 afa:	b7c9                	j	abc <ithread_create+0x90>
 afc:	ec26                	sd	s1,24(sp)
 afe:	b7bd                	j	a6c <ithread_create+0x40>
    free(stack_ptr);
 b00:	8526                	mv	a0,s1
 b02:	00000097          	auipc	ra,0x0
 b06:	c9c080e7          	jalr	-868(ra) # 79e <free>
    stacks[num_threads] = 0;
 b0a:	00000717          	auipc	a4,0x0
 b0e:	51672703          	lw	a4,1302(a4) # 1020 <num_threads>
 b12:	070e                	slli	a4,a4,0x3
 b14:	00000797          	auipc	a5,0x0
 b18:	5047b783          	ld	a5,1284(a5) # 1018 <stacks>
 b1c:	97ba                	add	a5,a5,a4
 b1e:	0007b023          	sd	zero,0(a5)
 b22:	64e2                	ld	s1,24(sp)
 b24:	bf61                	j	abc <ithread_create+0x90>

0000000000000b26 <ithread_join>:

int ithread_join(int thread_id) {
 b26:	1101                	addi	sp,sp,-32
 b28:	ec06                	sd	ra,24(sp)
 b2a:	e822                	sd	s0,16(sp)
 b2c:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b2e:	ff040793          	addi	a5,s0,-16
 b32:	ffc7859b          	addiw	a1,a5,-4
 b36:	00000097          	auipc	ra,0x0
 b3a:	90c080e7          	jalr	-1780(ra) # 442 <join_thread>
  threads_done++;
 b3e:	00000717          	auipc	a4,0x0
 b42:	4e670713          	addi	a4,a4,1254 # 1024 <threads_done>
 b46:	431c                	lw	a5,0(a4)
 b48:	2785                	addiw	a5,a5,1
 b4a:	0007869b          	sext.w	a3,a5
 b4e:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b50:	00000797          	auipc	a5,0x0
 b54:	4d07a783          	lw	a5,1232(a5) # 1020 <num_threads>
 b58:	00d78863          	beq	a5,a3,b68 <ithread_join+0x42>
    free_stacks();
  }
  return status;
}
 b5c:	fec42503          	lw	a0,-20(s0)
 b60:	60e2                	ld	ra,24(sp)
 b62:	6442                	ld	s0,16(sp)
 b64:	6105                	addi	sp,sp,32
 b66:	8082                	ret
    free_stacks();
 b68:	00000097          	auipc	ra,0x0
 b6c:	dd2080e7          	jalr	-558(ra) # 93a <free_stacks>
 b70:	b7f5                	j	b5c <ithread_join+0x36>
