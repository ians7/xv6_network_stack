
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	00001917          	auipc	s2,0x1
  18:	56c90913          	addi	s2,s2,1388 # 1580 <buf>
  1c:	20000a13          	li	s4,512
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	00000097          	auipc	ra,0x0
  2c:	3d8080e7          	jalr	984(ra) # 400 <read>
  30:	84aa                	mv	s1,a0
  32:	02a05963          	blez	a0,64 <cat+0x64>
    if (write(1, buf, n) != n) {
  36:	8626                	mv	a2,s1
  38:	85ca                	mv	a1,s2
  3a:	8556                	mv	a0,s5
  3c:	00000097          	auipc	ra,0x0
  40:	3cc080e7          	jalr	972(ra) # 408 <write>
  44:	fc950fe3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  48:	00001597          	auipc	a1,0x1
  4c:	b6858593          	addi	a1,a1,-1176 # bb0 <ithread_join+0x48>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	72c080e7          	jalr	1836(ra) # 77e <fprintf>
      exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	38c080e7          	jalr	908(ra) # 3e8 <exit>
    }
  }
  if(n < 0){
  64:	00054b63          	bltz	a0,7a <cat+0x7a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  68:	70e2                	ld	ra,56(sp)
  6a:	7442                	ld	s0,48(sp)
  6c:	74a2                	ld	s1,40(sp)
  6e:	7902                	ld	s2,32(sp)
  70:	69e2                	ld	s3,24(sp)
  72:	6a42                	ld	s4,16(sp)
  74:	6aa2                	ld	s5,8(sp)
  76:	6121                	addi	sp,sp,64
  78:	8082                	ret
    fprintf(2, "cat: read error\n");
  7a:	00001597          	auipc	a1,0x1
  7e:	b4e58593          	addi	a1,a1,-1202 # bc8 <ithread_join+0x60>
  82:	4509                	li	a0,2
  84:	00000097          	auipc	ra,0x0
  88:	6fa080e7          	jalr	1786(ra) # 77e <fprintf>
    exit(1);
  8c:	4505                	li	a0,1
  8e:	00000097          	auipc	ra,0x0
  92:	35a080e7          	jalr	858(ra) # 3e8 <exit>

0000000000000096 <main>:

int
main(int argc, char *argv[])
{
  96:	7179                	addi	sp,sp,-48
  98:	f406                	sd	ra,40(sp)
  9a:	f022                	sd	s0,32(sp)
  9c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  9e:	4785                	li	a5,1
  a0:	04a7da63          	bge	a5,a0,f4 <main+0x5e>
  a4:	ec26                	sd	s1,24(sp)
  a6:	e84a                	sd	s2,16(sp)
  a8:	e44e                	sd	s3,8(sp)
  aa:	00858913          	addi	s2,a1,8
  ae:	ffe5099b          	addiw	s3,a0,-2
  b2:	02099793          	slli	a5,s3,0x20
  b6:	01d7d993          	srli	s3,a5,0x1d
  ba:	05c1                	addi	a1,a1,16
  bc:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  be:	4581                	li	a1,0
  c0:	00093503          	ld	a0,0(s2)
  c4:	00000097          	auipc	ra,0x0
  c8:	364080e7          	jalr	868(ra) # 428 <open>
  cc:	84aa                	mv	s1,a0
  ce:	04054063          	bltz	a0,10e <main+0x78>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  d2:	00000097          	auipc	ra,0x0
  d6:	f2e080e7          	jalr	-210(ra) # 0 <cat>
    close(fd);
  da:	8526                	mv	a0,s1
  dc:	00000097          	auipc	ra,0x0
  e0:	334080e7          	jalr	820(ra) # 410 <close>
  for(i = 1; i < argc; i++){
  e4:	0921                	addi	s2,s2,8
  e6:	fd391ce3          	bne	s2,s3,be <main+0x28>
  }
  exit(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	2fc080e7          	jalr	764(ra) # 3e8 <exit>
  f4:	ec26                	sd	s1,24(sp)
  f6:	e84a                	sd	s2,16(sp)
  f8:	e44e                	sd	s3,8(sp)
    cat(0);
  fa:	4501                	li	a0,0
  fc:	00000097          	auipc	ra,0x0
 100:	f04080e7          	jalr	-252(ra) # 0 <cat>
    exit(0);
 104:	4501                	li	a0,0
 106:	00000097          	auipc	ra,0x0
 10a:	2e2080e7          	jalr	738(ra) # 3e8 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 10e:	00093603          	ld	a2,0(s2)
 112:	00001597          	auipc	a1,0x1
 116:	ace58593          	addi	a1,a1,-1330 # be0 <ithread_join+0x78>
 11a:	4509                	li	a0,2
 11c:	00000097          	auipc	ra,0x0
 120:	662080e7          	jalr	1634(ra) # 77e <fprintf>
      exit(1);
 124:	4505                	li	a0,1
 126:	00000097          	auipc	ra,0x0
 12a:	2c2080e7          	jalr	706(ra) # 3e8 <exit>

000000000000012e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 12e:	1141                	addi	sp,sp,-16
 130:	e406                	sd	ra,8(sp)
 132:	e022                	sd	s0,0(sp)
 134:	0800                	addi	s0,sp,16
  extern int main();
  main();
 136:	00000097          	auipc	ra,0x0
 13a:	f60080e7          	jalr	-160(ra) # 96 <main>
  exit(0);
 13e:	4501                	li	a0,0
 140:	00000097          	auipc	ra,0x0
 144:	2a8080e7          	jalr	680(ra) # 3e8 <exit>

0000000000000148 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 150:	87aa                	mv	a5,a0
 152:	0585                	addi	a1,a1,1
 154:	0785                	addi	a5,a5,1
 156:	fff5c703          	lbu	a4,-1(a1)
 15a:	fee78fa3          	sb	a4,-1(a5)
 15e:	fb75                	bnez	a4,152 <strcpy+0xa>
    ;
  return os;
}
 160:	60a2                	ld	ra,8(sp)
 162:	6402                	ld	s0,0(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret

0000000000000168 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e406                	sd	ra,8(sp)
 16c:	e022                	sd	s0,0(sp)
 16e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 170:	00054783          	lbu	a5,0(a0)
 174:	cb91                	beqz	a5,188 <strcmp+0x20>
 176:	0005c703          	lbu	a4,0(a1)
 17a:	00f71763          	bne	a4,a5,188 <strcmp+0x20>
    p++, q++;
 17e:	0505                	addi	a0,a0,1
 180:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 182:	00054783          	lbu	a5,0(a0)
 186:	fbe5                	bnez	a5,176 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 188:	0005c503          	lbu	a0,0(a1)
}
 18c:	40a7853b          	subw	a0,a5,a0
 190:	60a2                	ld	ra,8(sp)
 192:	6402                	ld	s0,0(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret

0000000000000198 <strlen>:

uint
strlen(const char *s)
{
 198:	1141                	addi	sp,sp,-16
 19a:	e406                	sd	ra,8(sp)
 19c:	e022                	sd	s0,0(sp)
 19e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1a0:	00054783          	lbu	a5,0(a0)
 1a4:	cf99                	beqz	a5,1c2 <strlen+0x2a>
 1a6:	0505                	addi	a0,a0,1
 1a8:	87aa                	mv	a5,a0
 1aa:	86be                	mv	a3,a5
 1ac:	0785                	addi	a5,a5,1
 1ae:	fff7c703          	lbu	a4,-1(a5)
 1b2:	ff65                	bnez	a4,1aa <strlen+0x12>
 1b4:	40a6853b          	subw	a0,a3,a0
 1b8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1ba:	60a2                	ld	ra,8(sp)
 1bc:	6402                	ld	s0,0(sp)
 1be:	0141                	addi	sp,sp,16
 1c0:	8082                	ret
  for(n = 0; s[n]; n++)
 1c2:	4501                	li	a0,0
 1c4:	bfdd                	j	1ba <strlen+0x22>

00000000000001c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e406                	sd	ra,8(sp)
 1ca:	e022                	sd	s0,0(sp)
 1cc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ce:	ca19                	beqz	a2,1e4 <memset+0x1e>
 1d0:	87aa                	mv	a5,a0
 1d2:	1602                	slli	a2,a2,0x20
 1d4:	9201                	srli	a2,a2,0x20
 1d6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1de:	0785                	addi	a5,a5,1
 1e0:	fee79de3          	bne	a5,a4,1da <memset+0x14>
  }
  return dst;
}
 1e4:	60a2                	ld	ra,8(sp)
 1e6:	6402                	ld	s0,0(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret

00000000000001ec <strchr>:

char*
strchr(const char *s, char c)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e406                	sd	ra,8(sp)
 1f0:	e022                	sd	s0,0(sp)
 1f2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1f4:	00054783          	lbu	a5,0(a0)
 1f8:	cf81                	beqz	a5,210 <strchr+0x24>
    if(*s == c)
 1fa:	00f58763          	beq	a1,a5,208 <strchr+0x1c>
  for(; *s; s++)
 1fe:	0505                	addi	a0,a0,1
 200:	00054783          	lbu	a5,0(a0)
 204:	fbfd                	bnez	a5,1fa <strchr+0xe>
      return (char*)s;
  return 0;
 206:	4501                	li	a0,0
}
 208:	60a2                	ld	ra,8(sp)
 20a:	6402                	ld	s0,0(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret
  return 0;
 210:	4501                	li	a0,0
 212:	bfdd                	j	208 <strchr+0x1c>

0000000000000214 <gets>:

char*
gets(char *buf, int max)
{
 214:	7159                	addi	sp,sp,-112
 216:	f486                	sd	ra,104(sp)
 218:	f0a2                	sd	s0,96(sp)
 21a:	eca6                	sd	s1,88(sp)
 21c:	e8ca                	sd	s2,80(sp)
 21e:	e4ce                	sd	s3,72(sp)
 220:	e0d2                	sd	s4,64(sp)
 222:	fc56                	sd	s5,56(sp)
 224:	f85a                	sd	s6,48(sp)
 226:	f45e                	sd	s7,40(sp)
 228:	f062                	sd	s8,32(sp)
 22a:	ec66                	sd	s9,24(sp)
 22c:	e86a                	sd	s10,16(sp)
 22e:	1880                	addi	s0,sp,112
 230:	8caa                	mv	s9,a0
 232:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 234:	892a                	mv	s2,a0
 236:	4481                	li	s1,0
    cc = read(0, &c, 1);
 238:	f9f40b13          	addi	s6,s0,-97
 23c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 23e:	4ba9                	li	s7,10
 240:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 242:	8d26                	mv	s10,s1
 244:	0014899b          	addiw	s3,s1,1
 248:	84ce                	mv	s1,s3
 24a:	0349d763          	bge	s3,s4,278 <gets+0x64>
    cc = read(0, &c, 1);
 24e:	8656                	mv	a2,s5
 250:	85da                	mv	a1,s6
 252:	4501                	li	a0,0
 254:	00000097          	auipc	ra,0x0
 258:	1ac080e7          	jalr	428(ra) # 400 <read>
    if(cc < 1)
 25c:	00a05e63          	blez	a0,278 <gets+0x64>
    buf[i++] = c;
 260:	f9f44783          	lbu	a5,-97(s0)
 264:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 268:	01778763          	beq	a5,s7,276 <gets+0x62>
 26c:	0905                	addi	s2,s2,1
 26e:	fd879ae3          	bne	a5,s8,242 <gets+0x2e>
    buf[i++] = c;
 272:	8d4e                	mv	s10,s3
 274:	a011                	j	278 <gets+0x64>
 276:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 278:	9d66                	add	s10,s10,s9
 27a:	000d0023          	sb	zero,0(s10)
  return buf;
}
 27e:	8566                	mv	a0,s9
 280:	70a6                	ld	ra,104(sp)
 282:	7406                	ld	s0,96(sp)
 284:	64e6                	ld	s1,88(sp)
 286:	6946                	ld	s2,80(sp)
 288:	69a6                	ld	s3,72(sp)
 28a:	6a06                	ld	s4,64(sp)
 28c:	7ae2                	ld	s5,56(sp)
 28e:	7b42                	ld	s6,48(sp)
 290:	7ba2                	ld	s7,40(sp)
 292:	7c02                	ld	s8,32(sp)
 294:	6ce2                	ld	s9,24(sp)
 296:	6d42                	ld	s10,16(sp)
 298:	6165                	addi	sp,sp,112
 29a:	8082                	ret

000000000000029c <stat>:

int
stat(const char *n, struct stat *st)
{
 29c:	1101                	addi	sp,sp,-32
 29e:	ec06                	sd	ra,24(sp)
 2a0:	e822                	sd	s0,16(sp)
 2a2:	e04a                	sd	s2,0(sp)
 2a4:	1000                	addi	s0,sp,32
 2a6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a8:	4581                	li	a1,0
 2aa:	00000097          	auipc	ra,0x0
 2ae:	17e080e7          	jalr	382(ra) # 428 <open>
  if(fd < 0)
 2b2:	02054663          	bltz	a0,2de <stat+0x42>
 2b6:	e426                	sd	s1,8(sp)
 2b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ba:	85ca                	mv	a1,s2
 2bc:	00000097          	auipc	ra,0x0
 2c0:	184080e7          	jalr	388(ra) # 440 <fstat>
 2c4:	892a                	mv	s2,a0
  close(fd);
 2c6:	8526                	mv	a0,s1
 2c8:	00000097          	auipc	ra,0x0
 2cc:	148080e7          	jalr	328(ra) # 410 <close>
  return r;
 2d0:	64a2                	ld	s1,8(sp)
}
 2d2:	854a                	mv	a0,s2
 2d4:	60e2                	ld	ra,24(sp)
 2d6:	6442                	ld	s0,16(sp)
 2d8:	6902                	ld	s2,0(sp)
 2da:	6105                	addi	sp,sp,32
 2dc:	8082                	ret
    return -1;
 2de:	597d                	li	s2,-1
 2e0:	bfcd                	j	2d2 <stat+0x36>

00000000000002e2 <atoi>:

int
atoi(const char *s)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e406                	sd	ra,8(sp)
 2e6:	e022                	sd	s0,0(sp)
 2e8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ea:	00054683          	lbu	a3,0(a0)
 2ee:	fd06879b          	addiw	a5,a3,-48
 2f2:	0ff7f793          	zext.b	a5,a5
 2f6:	4625                	li	a2,9
 2f8:	02f66963          	bltu	a2,a5,32a <atoi+0x48>
 2fc:	872a                	mv	a4,a0
  n = 0;
 2fe:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 300:	0705                	addi	a4,a4,1
 302:	0025179b          	slliw	a5,a0,0x2
 306:	9fa9                	addw	a5,a5,a0
 308:	0017979b          	slliw	a5,a5,0x1
 30c:	9fb5                	addw	a5,a5,a3
 30e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 312:	00074683          	lbu	a3,0(a4)
 316:	fd06879b          	addiw	a5,a3,-48
 31a:	0ff7f793          	zext.b	a5,a5
 31e:	fef671e3          	bgeu	a2,a5,300 <atoi+0x1e>
  return n;
}
 322:	60a2                	ld	ra,8(sp)
 324:	6402                	ld	s0,0(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret
  n = 0;
 32a:	4501                	li	a0,0
 32c:	bfdd                	j	322 <atoi+0x40>

000000000000032e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e406                	sd	ra,8(sp)
 332:	e022                	sd	s0,0(sp)
 334:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 336:	02b57563          	bgeu	a0,a1,360 <memmove+0x32>
    while(n-- > 0)
 33a:	00c05f63          	blez	a2,358 <memmove+0x2a>
 33e:	1602                	slli	a2,a2,0x20
 340:	9201                	srli	a2,a2,0x20
 342:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 346:	872a                	mv	a4,a0
      *dst++ = *src++;
 348:	0585                	addi	a1,a1,1
 34a:	0705                	addi	a4,a4,1
 34c:	fff5c683          	lbu	a3,-1(a1)
 350:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 354:	fee79ae3          	bne	a5,a4,348 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
    dst += n;
 360:	00c50733          	add	a4,a0,a2
    src += n;
 364:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 366:	fec059e3          	blez	a2,358 <memmove+0x2a>
 36a:	fff6079b          	addiw	a5,a2,-1
 36e:	1782                	slli	a5,a5,0x20
 370:	9381                	srli	a5,a5,0x20
 372:	fff7c793          	not	a5,a5
 376:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 378:	15fd                	addi	a1,a1,-1
 37a:	177d                	addi	a4,a4,-1
 37c:	0005c683          	lbu	a3,0(a1)
 380:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 384:	fef71ae3          	bne	a4,a5,378 <memmove+0x4a>
 388:	bfc1                	j	358 <memmove+0x2a>

000000000000038a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 392:	ca0d                	beqz	a2,3c4 <memcmp+0x3a>
 394:	fff6069b          	addiw	a3,a2,-1
 398:	1682                	slli	a3,a3,0x20
 39a:	9281                	srli	a3,a3,0x20
 39c:	0685                	addi	a3,a3,1
 39e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3a0:	00054783          	lbu	a5,0(a0)
 3a4:	0005c703          	lbu	a4,0(a1)
 3a8:	00e79863          	bne	a5,a4,3b8 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 3ac:	0505                	addi	a0,a0,1
    p2++;
 3ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b0:	fed518e3          	bne	a0,a3,3a0 <memcmp+0x16>
  }
  return 0;
 3b4:	4501                	li	a0,0
 3b6:	a019                	j	3bc <memcmp+0x32>
      return *p1 - *p2;
 3b8:	40e7853b          	subw	a0,a5,a4
}
 3bc:	60a2                	ld	ra,8(sp)
 3be:	6402                	ld	s0,0(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret
  return 0;
 3c4:	4501                	li	a0,0
 3c6:	bfdd                	j	3bc <memcmp+0x32>

00000000000003c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3c8:	1141                	addi	sp,sp,-16
 3ca:	e406                	sd	ra,8(sp)
 3cc:	e022                	sd	s0,0(sp)
 3ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3d0:	00000097          	auipc	ra,0x0
 3d4:	f5e080e7          	jalr	-162(ra) # 32e <memmove>
}
 3d8:	60a2                	ld	ra,8(sp)
 3da:	6402                	ld	s0,0(sp)
 3dc:	0141                	addi	sp,sp,16
 3de:	8082                	ret

00000000000003e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3e0:	4885                	li	a7,1
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3e8:	4889                	li	a7,2
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3f0:	488d                	li	a7,3
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3f8:	4891                	li	a7,4
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <read>:
.global read
read:
 li a7, SYS_read
 400:	4895                	li	a7,5
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <write>:
.global write
write:
 li a7, SYS_write
 408:	48c1                	li	a7,16
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <close>:
.global close
close:
 li a7, SYS_close
 410:	48d5                	li	a7,21
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <kill>:
.global kill
kill:
 li a7, SYS_kill
 418:	4899                	li	a7,6
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <exec>:
.global exec
exec:
 li a7, SYS_exec
 420:	489d                	li	a7,7
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <open>:
.global open
open:
 li a7, SYS_open
 428:	48bd                	li	a7,15
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 430:	48c5                	li	a7,17
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 438:	48c9                	li	a7,18
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 440:	48a1                	li	a7,8
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <link>:
.global link
link:
 li a7, SYS_link
 448:	48cd                	li	a7,19
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 450:	48d1                	li	a7,20
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 458:	48a5                	li	a7,9
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <dup>:
.global dup
dup:
 li a7, SYS_dup
 460:	48a9                	li	a7,10
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 468:	48ad                	li	a7,11
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 470:	48b1                	li	a7,12
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 478:	48b5                	li	a7,13
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 480:	48b9                	li	a7,14
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 488:	48d9                	li	a7,22
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 490:	48dd                	li	a7,23
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 498:	48e1                	li	a7,24
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 4a0:	48e5                	li	a7,25
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <socket>:
.global socket
socket:
 li a7, SYS_socket
 4a8:	48e9                	li	a7,26
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <bind>:
.global bind
bind:
 li a7, SYS_bind
 4b0:	48ed                	li	a7,27
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <accept>:
.global accept
accept:
 li a7, SYS_accept
 4b8:	48f5                	li	a7,29
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <listen>:
.global listen
listen:
 li a7, SYS_listen
 4c0:	48f1                	li	a7,28
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <connect>:
.global connect
connect:
 li a7, SYS_connect
 4c8:	48f9                	li	a7,30
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <send>:
.global send
send:
 li a7, SYS_send
 4d0:	48fd                	li	a7,31
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <recv>:
.global recv
recv:
 li a7, SYS_recv
 4d8:	02000893          	li	a7,32
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 4e2:	02100893          	li	a7,33
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 4ec:	02200893          	li	a7,34
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f6:	1101                	addi	sp,sp,-32
 4f8:	ec06                	sd	ra,24(sp)
 4fa:	e822                	sd	s0,16(sp)
 4fc:	1000                	addi	s0,sp,32
 4fe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 502:	4605                	li	a2,1
 504:	fef40593          	addi	a1,s0,-17
 508:	00000097          	auipc	ra,0x0
 50c:	f00080e7          	jalr	-256(ra) # 408 <write>
}
 510:	60e2                	ld	ra,24(sp)
 512:	6442                	ld	s0,16(sp)
 514:	6105                	addi	sp,sp,32
 516:	8082                	ret

0000000000000518 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 518:	7139                	addi	sp,sp,-64
 51a:	fc06                	sd	ra,56(sp)
 51c:	f822                	sd	s0,48(sp)
 51e:	f426                	sd	s1,40(sp)
 520:	f04a                	sd	s2,32(sp)
 522:	ec4e                	sd	s3,24(sp)
 524:	0080                	addi	s0,sp,64
 526:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 528:	c299                	beqz	a3,52e <printint+0x16>
 52a:	0805c063          	bltz	a1,5aa <printint+0x92>
  neg = 0;
 52e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 530:	fc040313          	addi	t1,s0,-64
  neg = 0;
 534:	869a                	mv	a3,t1
  i = 0;
 536:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 538:	00000817          	auipc	a6,0x0
 53c:	75080813          	addi	a6,a6,1872 # c88 <digits>
 540:	88be                	mv	a7,a5
 542:	0017851b          	addiw	a0,a5,1
 546:	87aa                	mv	a5,a0
 548:	02c5f73b          	remuw	a4,a1,a2
 54c:	1702                	slli	a4,a4,0x20
 54e:	9301                	srli	a4,a4,0x20
 550:	9742                	add	a4,a4,a6
 552:	00074703          	lbu	a4,0(a4)
 556:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 55a:	872e                	mv	a4,a1
 55c:	02c5d5bb          	divuw	a1,a1,a2
 560:	0685                	addi	a3,a3,1
 562:	fcc77fe3          	bgeu	a4,a2,540 <printint+0x28>
  if(neg)
 566:	000e0c63          	beqz	t3,57e <printint+0x66>
    buf[i++] = '-';
 56a:	fd050793          	addi	a5,a0,-48
 56e:	00878533          	add	a0,a5,s0
 572:	02d00793          	li	a5,45
 576:	fef50823          	sb	a5,-16(a0)
 57a:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 57e:	fff7899b          	addiw	s3,a5,-1
 582:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 586:	fff4c583          	lbu	a1,-1(s1)
 58a:	854a                	mv	a0,s2
 58c:	00000097          	auipc	ra,0x0
 590:	f6a080e7          	jalr	-150(ra) # 4f6 <putc>
  while(--i >= 0)
 594:	39fd                	addiw	s3,s3,-1
 596:	14fd                	addi	s1,s1,-1
 598:	fe09d7e3          	bgez	s3,586 <printint+0x6e>
}
 59c:	70e2                	ld	ra,56(sp)
 59e:	7442                	ld	s0,48(sp)
 5a0:	74a2                	ld	s1,40(sp)
 5a2:	7902                	ld	s2,32(sp)
 5a4:	69e2                	ld	s3,24(sp)
 5a6:	6121                	addi	sp,sp,64
 5a8:	8082                	ret
    x = -xx;
 5aa:	40b005bb          	negw	a1,a1
    neg = 1;
 5ae:	4e05                	li	t3,1
    x = -xx;
 5b0:	b741                	j	530 <printint+0x18>

00000000000005b2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b2:	715d                	addi	sp,sp,-80
 5b4:	e486                	sd	ra,72(sp)
 5b6:	e0a2                	sd	s0,64(sp)
 5b8:	f84a                	sd	s2,48(sp)
 5ba:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5bc:	0005c903          	lbu	s2,0(a1)
 5c0:	1a090a63          	beqz	s2,774 <vprintf+0x1c2>
 5c4:	fc26                	sd	s1,56(sp)
 5c6:	f44e                	sd	s3,40(sp)
 5c8:	f052                	sd	s4,32(sp)
 5ca:	ec56                	sd	s5,24(sp)
 5cc:	e85a                	sd	s6,16(sp)
 5ce:	e45e                	sd	s7,8(sp)
 5d0:	8aaa                	mv	s5,a0
 5d2:	8bb2                	mv	s7,a2
 5d4:	00158493          	addi	s1,a1,1
  state = 0;
 5d8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5da:	02500a13          	li	s4,37
 5de:	4b55                	li	s6,21
 5e0:	a839                	j	5fe <vprintf+0x4c>
        putc(fd, c);
 5e2:	85ca                	mv	a1,s2
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	f10080e7          	jalr	-240(ra) # 4f6 <putc>
 5ee:	a019                	j	5f4 <vprintf+0x42>
    } else if(state == '%'){
 5f0:	01498d63          	beq	s3,s4,60a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5f4:	0485                	addi	s1,s1,1
 5f6:	fff4c903          	lbu	s2,-1(s1)
 5fa:	16090763          	beqz	s2,768 <vprintf+0x1b6>
    if(state == 0){
 5fe:	fe0999e3          	bnez	s3,5f0 <vprintf+0x3e>
      if(c == '%'){
 602:	ff4910e3          	bne	s2,s4,5e2 <vprintf+0x30>
        state = '%';
 606:	89d2                	mv	s3,s4
 608:	b7f5                	j	5f4 <vprintf+0x42>
      if(c == 'd'){
 60a:	13490463          	beq	s2,s4,732 <vprintf+0x180>
 60e:	f9d9079b          	addiw	a5,s2,-99
 612:	0ff7f793          	zext.b	a5,a5
 616:	12fb6763          	bltu	s6,a5,744 <vprintf+0x192>
 61a:	f9d9079b          	addiw	a5,s2,-99
 61e:	0ff7f713          	zext.b	a4,a5
 622:	12eb6163          	bltu	s6,a4,744 <vprintf+0x192>
 626:	00271793          	slli	a5,a4,0x2
 62a:	00000717          	auipc	a4,0x0
 62e:	60670713          	addi	a4,a4,1542 # c30 <ithread_join+0xc8>
 632:	97ba                	add	a5,a5,a4
 634:	439c                	lw	a5,0(a5)
 636:	97ba                	add	a5,a5,a4
 638:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4685                	li	a3,1
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	ed0080e7          	jalr	-304(ra) # 518 <printint>
 650:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 652:	4981                	li	s3,0
 654:	b745                	j	5f4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 656:	008b8913          	addi	s2,s7,8
 65a:	4681                	li	a3,0
 65c:	4629                	li	a2,10
 65e:	000ba583          	lw	a1,0(s7)
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	eb4080e7          	jalr	-332(ra) # 518 <printint>
 66c:	8bca                	mv	s7,s2
      state = 0;
 66e:	4981                	li	s3,0
 670:	b751                	j	5f4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 672:	008b8913          	addi	s2,s7,8
 676:	4681                	li	a3,0
 678:	4641                	li	a2,16
 67a:	000ba583          	lw	a1,0(s7)
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	e98080e7          	jalr	-360(ra) # 518 <printint>
 688:	8bca                	mv	s7,s2
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b7a5                	j	5f4 <vprintf+0x42>
 68e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 690:	008b8c13          	addi	s8,s7,8
 694:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 698:	03000593          	li	a1,48
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	e58080e7          	jalr	-424(ra) # 4f6 <putc>
  putc(fd, 'x');
 6a6:	07800593          	li	a1,120
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	e4a080e7          	jalr	-438(ra) # 4f6 <putc>
 6b4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b6:	00000b97          	auipc	s7,0x0
 6ba:	5d2b8b93          	addi	s7,s7,1490 # c88 <digits>
 6be:	03c9d793          	srli	a5,s3,0x3c
 6c2:	97de                	add	a5,a5,s7
 6c4:	0007c583          	lbu	a1,0(a5)
 6c8:	8556                	mv	a0,s5
 6ca:	00000097          	auipc	ra,0x0
 6ce:	e2c080e7          	jalr	-468(ra) # 4f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d2:	0992                	slli	s3,s3,0x4
 6d4:	397d                	addiw	s2,s2,-1
 6d6:	fe0914e3          	bnez	s2,6be <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6da:	8be2                	mv	s7,s8
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	6c02                	ld	s8,0(sp)
 6e0:	bf11                	j	5f4 <vprintf+0x42>
        s = va_arg(ap, char*);
 6e2:	008b8993          	addi	s3,s7,8
 6e6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6ea:	02090163          	beqz	s2,70c <vprintf+0x15a>
        while(*s != 0){
 6ee:	00094583          	lbu	a1,0(s2)
 6f2:	c9a5                	beqz	a1,762 <vprintf+0x1b0>
          putc(fd, *s);
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e00080e7          	jalr	-512(ra) # 4f6 <putc>
          s++;
 6fe:	0905                	addi	s2,s2,1
        while(*s != 0){
 700:	00094583          	lbu	a1,0(s2)
 704:	f9e5                	bnez	a1,6f4 <vprintf+0x142>
        s = va_arg(ap, char*);
 706:	8bce                	mv	s7,s3
      state = 0;
 708:	4981                	li	s3,0
 70a:	b5ed                	j	5f4 <vprintf+0x42>
          s = "(null)";
 70c:	00000917          	auipc	s2,0x0
 710:	4ec90913          	addi	s2,s2,1260 # bf8 <ithread_join+0x90>
        while(*s != 0){
 714:	02800593          	li	a1,40
 718:	bff1                	j	6f4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 71a:	008b8913          	addi	s2,s7,8
 71e:	000bc583          	lbu	a1,0(s7)
 722:	8556                	mv	a0,s5
 724:	00000097          	auipc	ra,0x0
 728:	dd2080e7          	jalr	-558(ra) # 4f6 <putc>
 72c:	8bca                	mv	s7,s2
      state = 0;
 72e:	4981                	li	s3,0
 730:	b5d1                	j	5f4 <vprintf+0x42>
        putc(fd, c);
 732:	02500593          	li	a1,37
 736:	8556                	mv	a0,s5
 738:	00000097          	auipc	ra,0x0
 73c:	dbe080e7          	jalr	-578(ra) # 4f6 <putc>
      state = 0;
 740:	4981                	li	s3,0
 742:	bd4d                	j	5f4 <vprintf+0x42>
        putc(fd, '%');
 744:	02500593          	li	a1,37
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	dac080e7          	jalr	-596(ra) # 4f6 <putc>
        putc(fd, c);
 752:	85ca                	mv	a1,s2
 754:	8556                	mv	a0,s5
 756:	00000097          	auipc	ra,0x0
 75a:	da0080e7          	jalr	-608(ra) # 4f6 <putc>
      state = 0;
 75e:	4981                	li	s3,0
 760:	bd51                	j	5f4 <vprintf+0x42>
        s = va_arg(ap, char*);
 762:	8bce                	mv	s7,s3
      state = 0;
 764:	4981                	li	s3,0
 766:	b579                	j	5f4 <vprintf+0x42>
 768:	74e2                	ld	s1,56(sp)
 76a:	79a2                	ld	s3,40(sp)
 76c:	7a02                	ld	s4,32(sp)
 76e:	6ae2                	ld	s5,24(sp)
 770:	6b42                	ld	s6,16(sp)
 772:	6ba2                	ld	s7,8(sp)
    }
  }
}
 774:	60a6                	ld	ra,72(sp)
 776:	6406                	ld	s0,64(sp)
 778:	7942                	ld	s2,48(sp)
 77a:	6161                	addi	sp,sp,80
 77c:	8082                	ret

000000000000077e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 77e:	715d                	addi	sp,sp,-80
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e010                	sd	a2,0(s0)
 788:	e414                	sd	a3,8(s0)
 78a:	e818                	sd	a4,16(s0)
 78c:	ec1c                	sd	a5,24(s0)
 78e:	03043023          	sd	a6,32(s0)
 792:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 796:	8622                	mv	a2,s0
 798:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79c:	00000097          	auipc	ra,0x0
 7a0:	e16080e7          	jalr	-490(ra) # 5b2 <vprintf>
}
 7a4:	60e2                	ld	ra,24(sp)
 7a6:	6442                	ld	s0,16(sp)
 7a8:	6161                	addi	sp,sp,80
 7aa:	8082                	ret

00000000000007ac <printf>:

void
printf(const char *fmt, ...)
{
 7ac:	711d                	addi	sp,sp,-96
 7ae:	ec06                	sd	ra,24(sp)
 7b0:	e822                	sd	s0,16(sp)
 7b2:	1000                	addi	s0,sp,32
 7b4:	e40c                	sd	a1,8(s0)
 7b6:	e810                	sd	a2,16(s0)
 7b8:	ec14                	sd	a3,24(s0)
 7ba:	f018                	sd	a4,32(s0)
 7bc:	f41c                	sd	a5,40(s0)
 7be:	03043823          	sd	a6,48(s0)
 7c2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c6:	00840613          	addi	a2,s0,8
 7ca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ce:	85aa                	mv	a1,a0
 7d0:	4505                	li	a0,1
 7d2:	00000097          	auipc	ra,0x0
 7d6:	de0080e7          	jalr	-544(ra) # 5b2 <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6125                	addi	sp,sp,96
 7e0:	8082                	ret

00000000000007e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e2:	1141                	addi	sp,sp,-16
 7e4:	e406                	sd	ra,8(sp)
 7e6:	e022                	sd	s0,0(sp)
 7e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	00001797          	auipc	a5,0x1
 7f2:	d727b783          	ld	a5,-654(a5) # 1560 <freep>
 7f6:	a02d                	j	820 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7f8:	4618                	lw	a4,8(a2)
 7fa:	9f2d                	addw	a4,a4,a1
 7fc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 800:	6398                	ld	a4,0(a5)
 802:	6310                	ld	a2,0(a4)
 804:	a83d                	j	842 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 806:	ff852703          	lw	a4,-8(a0)
 80a:	9f31                	addw	a4,a4,a2
 80c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 80e:	ff053683          	ld	a3,-16(a0)
 812:	a091                	j	856 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 814:	6398                	ld	a4,0(a5)
 816:	00e7e463          	bltu	a5,a4,81e <free+0x3c>
 81a:	00e6ea63          	bltu	a3,a4,82e <free+0x4c>
{
 81e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 820:	fed7fae3          	bgeu	a5,a3,814 <free+0x32>
 824:	6398                	ld	a4,0(a5)
 826:	00e6e463          	bltu	a3,a4,82e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82a:	fee7eae3          	bltu	a5,a4,81e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 82e:	ff852583          	lw	a1,-8(a0)
 832:	6390                	ld	a2,0(a5)
 834:	02059813          	slli	a6,a1,0x20
 838:	01c85713          	srli	a4,a6,0x1c
 83c:	9736                	add	a4,a4,a3
 83e:	fae60de3          	beq	a2,a4,7f8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 842:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 846:	4790                	lw	a2,8(a5)
 848:	02061593          	slli	a1,a2,0x20
 84c:	01c5d713          	srli	a4,a1,0x1c
 850:	973e                	add	a4,a4,a5
 852:	fae68ae3          	beq	a3,a4,806 <free+0x24>
    p->s.ptr = bp->s.ptr;
 856:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 858:	00001717          	auipc	a4,0x1
 85c:	d0f73423          	sd	a5,-760(a4) # 1560 <freep>
}
 860:	60a2                	ld	ra,8(sp)
 862:	6402                	ld	s0,0(sp)
 864:	0141                	addi	sp,sp,16
 866:	8082                	ret

0000000000000868 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 868:	7139                	addi	sp,sp,-64
 86a:	fc06                	sd	ra,56(sp)
 86c:	f822                	sd	s0,48(sp)
 86e:	f04a                	sd	s2,32(sp)
 870:	ec4e                	sd	s3,24(sp)
 872:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 874:	02051993          	slli	s3,a0,0x20
 878:	0209d993          	srli	s3,s3,0x20
 87c:	09bd                	addi	s3,s3,15
 87e:	0049d993          	srli	s3,s3,0x4
 882:	2985                	addiw	s3,s3,1
 884:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 886:	00001517          	auipc	a0,0x1
 88a:	cda53503          	ld	a0,-806(a0) # 1560 <freep>
 88e:	c905                	beqz	a0,8be <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 890:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 892:	4798                	lw	a4,8(a5)
 894:	09377a63          	bgeu	a4,s3,928 <malloc+0xc0>
 898:	f426                	sd	s1,40(sp)
 89a:	e852                	sd	s4,16(sp)
 89c:	e456                	sd	s5,8(sp)
 89e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8a0:	8a4e                	mv	s4,s3
 8a2:	6705                	lui	a4,0x1
 8a4:	00e9f363          	bgeu	s3,a4,8aa <malloc+0x42>
 8a8:	6a05                	lui	s4,0x1
 8aa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b2:	00001497          	auipc	s1,0x1
 8b6:	cae48493          	addi	s1,s1,-850 # 1560 <freep>
  if(p == (char*)-1)
 8ba:	5afd                	li	s5,-1
 8bc:	a089                	j	8fe <malloc+0x96>
 8be:	f426                	sd	s1,40(sp)
 8c0:	e852                	sd	s4,16(sp)
 8c2:	e456                	sd	s5,8(sp)
 8c4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8c6:	00001797          	auipc	a5,0x1
 8ca:	eba78793          	addi	a5,a5,-326 # 1780 <base>
 8ce:	00001717          	auipc	a4,0x1
 8d2:	c8f73923          	sd	a5,-878(a4) # 1560 <freep>
 8d6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8dc:	b7d1                	j	8a0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8de:	6398                	ld	a4,0(a5)
 8e0:	e118                	sd	a4,0(a0)
 8e2:	a8b9                	j	940 <malloc+0xd8>
  hp->s.size = nu;
 8e4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e8:	0541                	addi	a0,a0,16
 8ea:	00000097          	auipc	ra,0x0
 8ee:	ef8080e7          	jalr	-264(ra) # 7e2 <free>
  return freep;
 8f2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8f4:	c135                	beqz	a0,958 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f8:	4798                	lw	a4,8(a5)
 8fa:	03277363          	bgeu	a4,s2,920 <malloc+0xb8>
    if(p == freep)
 8fe:	6098                	ld	a4,0(s1)
 900:	853e                	mv	a0,a5
 902:	fef71ae3          	bne	a4,a5,8f6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 906:	8552                	mv	a0,s4
 908:	00000097          	auipc	ra,0x0
 90c:	b68080e7          	jalr	-1176(ra) # 470 <sbrk>
  if(p == (char*)-1)
 910:	fd551ae3          	bne	a0,s5,8e4 <malloc+0x7c>
        return 0;
 914:	4501                	li	a0,0
 916:	74a2                	ld	s1,40(sp)
 918:	6a42                	ld	s4,16(sp)
 91a:	6aa2                	ld	s5,8(sp)
 91c:	6b02                	ld	s6,0(sp)
 91e:	a03d                	j	94c <malloc+0xe4>
 920:	74a2                	ld	s1,40(sp)
 922:	6a42                	ld	s4,16(sp)
 924:	6aa2                	ld	s5,8(sp)
 926:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 928:	fae90be3          	beq	s2,a4,8de <malloc+0x76>
        p->s.size -= nunits;
 92c:	4137073b          	subw	a4,a4,s3
 930:	c798                	sw	a4,8(a5)
        p += p->s.size;
 932:	02071693          	slli	a3,a4,0x20
 936:	01c6d713          	srli	a4,a3,0x1c
 93a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 940:	00001717          	auipc	a4,0x1
 944:	c2a73023          	sd	a0,-992(a4) # 1560 <freep>
      return (void*)(p + 1);
 948:	01078513          	addi	a0,a5,16
  }
}
 94c:	70e2                	ld	ra,56(sp)
 94e:	7442                	ld	s0,48(sp)
 950:	7902                	ld	s2,32(sp)
 952:	69e2                	ld	s3,24(sp)
 954:	6121                	addi	sp,sp,64
 956:	8082                	ret
 958:	74a2                	ld	s1,40(sp)
 95a:	6a42                	ld	s4,16(sp)
 95c:	6aa2                	ld	s5,8(sp)
 95e:	6b02                	ld	s6,0(sp)
 960:	b7f5                	j	94c <malloc+0xe4>

0000000000000962 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 962:	1141                	addi	sp,sp,-16
 964:	e406                	sd	ra,8(sp)
 966:	e022                	sd	s0,0(sp)
 968:	0800                	addi	s0,sp,16
  thread_exit(status);
 96a:	2501                	sext.w	a0,a0
 96c:	00000097          	auipc	ra,0x0
 970:	b34080e7          	jalr	-1228(ra) # 4a0 <thread_exit>
}
 974:	60a2                	ld	ra,8(sp)
 976:	6402                	ld	s0,0(sp)
 978:	0141                	addi	sp,sp,16
 97a:	8082                	ret

000000000000097c <free_stacks>:
int free_stacks() {
 97c:	7179                	addi	sp,sp,-48
 97e:	f406                	sd	ra,40(sp)
 980:	f022                	sd	s0,32(sp)
 982:	ec26                	sd	s1,24(sp)
 984:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 986:	00001797          	auipc	a5,0x1
 98a:	bea7a783          	lw	a5,-1046(a5) # 1570 <num_threads>
 98e:	04f05063          	blez	a5,9ce <free_stacks+0x52>
 992:	e84a                	sd	s2,16(sp)
 994:	e44e                	sd	s3,8(sp)
 996:	4481                	li	s1,0
    free(stacks[i]);
 998:	00001997          	auipc	s3,0x1
 99c:	bd098993          	addi	s3,s3,-1072 # 1568 <stacks>
  for (int i = 0; i < num_threads; i++) {
 9a0:	00001917          	auipc	s2,0x1
 9a4:	bd090913          	addi	s2,s2,-1072 # 1570 <num_threads>
    free(stacks[i]);
 9a8:	0009b783          	ld	a5,0(s3)
 9ac:	00349713          	slli	a4,s1,0x3
 9b0:	97ba                	add	a5,a5,a4
 9b2:	6388                	ld	a0,0(a5)
 9b4:	00000097          	auipc	ra,0x0
 9b8:	e2e080e7          	jalr	-466(ra) # 7e2 <free>
  for (int i = 0; i < num_threads; i++) {
 9bc:	0485                	addi	s1,s1,1
 9be:	00092703          	lw	a4,0(s2)
 9c2:	0004879b          	sext.w	a5,s1
 9c6:	fee7c1e3          	blt	a5,a4,9a8 <free_stacks+0x2c>
 9ca:	6942                	ld	s2,16(sp)
 9cc:	69a2                	ld	s3,8(sp)
  free(stacks);
 9ce:	00001497          	auipc	s1,0x1
 9d2:	b9a48493          	addi	s1,s1,-1126 # 1568 <stacks>
 9d6:	6088                	ld	a0,0(s1)
 9d8:	00000097          	auipc	ra,0x0
 9dc:	e0a080e7          	jalr	-502(ra) # 7e2 <free>
  stacks = 0;
 9e0:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 9e4:	00001797          	auipc	a5,0x1
 9e8:	b807a623          	sw	zero,-1140(a5) # 1570 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 9ec:	47a1                	li	a5,8
 9ee:	00001717          	auipc	a4,0x1
 9f2:	b6f72123          	sw	a5,-1182(a4) # 1550 <max_stacks>
  threads_done = 0;
 9f6:	00001797          	auipc	a5,0x1
 9fa:	b607af23          	sw	zero,-1154(a5) # 1574 <threads_done>
}
 9fe:	4501                	li	a0,0
 a00:	70a2                	ld	ra,40(sp)
 a02:	7402                	ld	s0,32(sp)
 a04:	64e2                	ld	s1,24(sp)
 a06:	6145                	addi	sp,sp,48
 a08:	8082                	ret

0000000000000a0a <expand_num_threads>:
int expand_num_threads() {
 a0a:	1101                	addi	sp,sp,-32
 a0c:	ec06                	sd	ra,24(sp)
 a0e:	e822                	sd	s0,16(sp)
 a10:	e426                	sd	s1,8(sp)
 a12:	e04a                	sd	s2,0(sp)
 a14:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 a16:	00001797          	auipc	a5,0x1
 a1a:	b3a78793          	addi	a5,a5,-1222 # 1550 <max_stacks>
 a1e:	4388                	lw	a0,0(a5)
 a20:	0015151b          	slliw	a0,a0,0x1
 a24:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a26:	0035151b          	slliw	a0,a0,0x3
 a2a:	00000097          	auipc	ra,0x0
 a2e:	e3e080e7          	jalr	-450(ra) # 868 <malloc>
 a32:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a34:	00001617          	auipc	a2,0x1
 a38:	b3c62603          	lw	a2,-1220(a2) # 1570 <num_threads>
 a3c:	00001497          	auipc	s1,0x1
 a40:	b2c48493          	addi	s1,s1,-1236 # 1568 <stacks>
 a44:	0036161b          	slliw	a2,a2,0x3
 a48:	608c                	ld	a1,0(s1)
 a4a:	00000097          	auipc	ra,0x0
 a4e:	8e4080e7          	jalr	-1820(ra) # 32e <memmove>
  free(stacks);
 a52:	6088                	ld	a0,0(s1)
 a54:	00000097          	auipc	ra,0x0
 a58:	d8e080e7          	jalr	-626(ra) # 7e2 <free>
  stacks = new_stacks;
 a5c:	0124b023          	sd	s2,0(s1)
}
 a60:	4501                	li	a0,0
 a62:	60e2                	ld	ra,24(sp)
 a64:	6442                	ld	s0,16(sp)
 a66:	64a2                	ld	s1,8(sp)
 a68:	6902                	ld	s2,0(sp)
 a6a:	6105                	addi	sp,sp,32
 a6c:	8082                	ret

0000000000000a6e <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a6e:	7179                	addi	sp,sp,-48
 a70:	f406                	sd	ra,40(sp)
 a72:	f022                	sd	s0,32(sp)
 a74:	e84a                	sd	s2,16(sp)
 a76:	e44e                	sd	s3,8(sp)
 a78:	1800                	addi	s0,sp,48
 a7a:	892a                	mv	s2,a0
 a7c:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a7e:	00001797          	auipc	a5,0x1
 a82:	aea7b783          	ld	a5,-1302(a5) # 1568 <stacks>
 a86:	c3d9                	beqz	a5,b0c <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a88:	00001797          	auipc	a5,0x1
 a8c:	ac87a783          	lw	a5,-1336(a5) # 1550 <max_stacks>
 a90:	00001717          	auipc	a4,0x1
 a94:	ae072703          	lw	a4,-1312(a4) # 1570 <num_threads>
 a98:	0af71363          	bne	a4,a5,b3e <ithread_create+0xd0>
    if (max_stacks == MAX_THREADS) {
 a9c:	04000713          	li	a4,64
 aa0:	08e78563          	beq	a5,a4,b2a <ithread_create+0xbc>
 aa4:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 aa6:	00000097          	auipc	ra,0x0
 aaa:	f64080e7          	jalr	-156(ra) # a0a <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 aae:	6505                	lui	a0,0x1
 ab0:	00000097          	auipc	ra,0x0
 ab4:	db8080e7          	jalr	-584(ra) # 868 <malloc>
 ab8:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 aba:	00001717          	auipc	a4,0x1
 abe:	ab672703          	lw	a4,-1354(a4) # 1570 <num_threads>
 ac2:	070e                	slli	a4,a4,0x3
 ac4:	00001797          	auipc	a5,0x1
 ac8:	aa47b783          	ld	a5,-1372(a5) # 1568 <stacks>
 acc:	97ba                	add	a5,a5,a4
 ace:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 ad0:	00000697          	auipc	a3,0x0
 ad4:	e9268693          	addi	a3,a3,-366 # 962 <ithread_exit>
 ad8:	862a                	mv	a2,a0
 ada:	85ce                	mv	a1,s3
 adc:	854a                	mv	a0,s2
 ade:	00000097          	auipc	ra,0x0
 ae2:	9b2080e7          	jalr	-1614(ra) # 490 <create_thread>
 ae6:	892a                	mv	s2,a0
  if (res != -1) {
 ae8:	57fd                	li	a5,-1
 aea:	04f50c63          	beq	a0,a5,b42 <ithread_create+0xd4>
    num_threads++;
 aee:	00001717          	auipc	a4,0x1
 af2:	a8270713          	addi	a4,a4,-1406 # 1570 <num_threads>
 af6:	431c                	lw	a5,0(a4)
 af8:	2785                	addiw	a5,a5,1
 afa:	c31c                	sw	a5,0(a4)
 afc:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 afe:	854a                	mv	a0,s2
 b00:	70a2                	ld	ra,40(sp)
 b02:	7402                	ld	s0,32(sp)
 b04:	6942                	ld	s2,16(sp)
 b06:	69a2                	ld	s3,8(sp)
 b08:	6145                	addi	sp,sp,48
 b0a:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 b0c:	00001517          	auipc	a0,0x1
 b10:	a4452503          	lw	a0,-1468(a0) # 1550 <max_stacks>
 b14:	0035151b          	slliw	a0,a0,0x3
 b18:	00000097          	auipc	ra,0x0
 b1c:	d50080e7          	jalr	-688(ra) # 868 <malloc>
 b20:	00001797          	auipc	a5,0x1
 b24:	a4a7b423          	sd	a0,-1464(a5) # 1568 <stacks>
 b28:	b785                	j	a88 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b2a:	00000517          	auipc	a0,0x0
 b2e:	0d650513          	addi	a0,a0,214 # c00 <ithread_join+0x98>
 b32:	00000097          	auipc	ra,0x0
 b36:	c7a080e7          	jalr	-902(ra) # 7ac <printf>
      return -1;
 b3a:	597d                	li	s2,-1
 b3c:	b7c9                	j	afe <ithread_create+0x90>
 b3e:	ec26                	sd	s1,24(sp)
 b40:	b7bd                	j	aae <ithread_create+0x40>
    free(stack_ptr);
 b42:	8526                	mv	a0,s1
 b44:	00000097          	auipc	ra,0x0
 b48:	c9e080e7          	jalr	-866(ra) # 7e2 <free>
    stacks[num_threads] = 0;
 b4c:	00001717          	auipc	a4,0x1
 b50:	a2472703          	lw	a4,-1500(a4) # 1570 <num_threads>
 b54:	070e                	slli	a4,a4,0x3
 b56:	00001797          	auipc	a5,0x1
 b5a:	a127b783          	ld	a5,-1518(a5) # 1568 <stacks>
 b5e:	97ba                	add	a5,a5,a4
 b60:	0007b023          	sd	zero,0(a5)
 b64:	64e2                	ld	s1,24(sp)
 b66:	bf61                	j	afe <ithread_create+0x90>

0000000000000b68 <ithread_join>:

int ithread_join(int thread_id) {
 b68:	1101                	addi	sp,sp,-32
 b6a:	ec06                	sd	ra,24(sp)
 b6c:	e822                	sd	s0,16(sp)
 b6e:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b70:	ff040793          	addi	a5,s0,-16
 b74:	ffc7859b          	addiw	a1,a5,-4
 b78:	00000097          	auipc	ra,0x0
 b7c:	920080e7          	jalr	-1760(ra) # 498 <join_thread>
  threads_done++;
 b80:	00001717          	auipc	a4,0x1
 b84:	9f470713          	addi	a4,a4,-1548 # 1574 <threads_done>
 b88:	431c                	lw	a5,0(a4)
 b8a:	2785                	addiw	a5,a5,1
 b8c:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b8e:	00001717          	auipc	a4,0x1
 b92:	9e272703          	lw	a4,-1566(a4) # 1570 <num_threads>
 b96:	00f70863          	beq	a4,a5,ba6 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 b9a:	fec42503          	lw	a0,-20(s0)
 b9e:	60e2                	ld	ra,24(sp)
 ba0:	6442                	ld	s0,16(sp)
 ba2:	6105                	addi	sp,sp,32
 ba4:	8082                	ret
    free_stacks();
 ba6:	00000097          	auipc	ra,0x0
 baa:	dd6080e7          	jalr	-554(ra) # 97c <free_stacks>
 bae:	b7f5                	j	b9a <ithread_join+0x32>
