
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
  14:	20000a13          	li	s4,512
  18:	00001917          	auipc	s2,0x1
  1c:	56890913          	addi	s2,s2,1384 # 1580 <buf>
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	00000097          	auipc	ra,0x0
  2c:	3c6080e7          	jalr	966(ra) # 3ee <read>
  30:	84aa                	mv	s1,a0
  32:	02a05963          	blez	a0,64 <cat+0x64>
    if (write(1, buf, n) != n) {
  36:	8626                	mv	a2,s1
  38:	85ca                	mv	a1,s2
  3a:	8556                	mv	a0,s5
  3c:	00000097          	auipc	ra,0x0
  40:	3ba080e7          	jalr	954(ra) # 3f6 <write>
  44:	fc950fe3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  48:	00001597          	auipc	a1,0x1
  4c:	b4858593          	addi	a1,a1,-1208 # b90 <ithread_join+0x4e>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	704080e7          	jalr	1796(ra) # 756 <fprintf>
      exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	37a080e7          	jalr	890(ra) # 3d6 <exit>
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
  7e:	b2e58593          	addi	a1,a1,-1234 # ba8 <ithread_join+0x66>
  82:	4509                	li	a0,2
  84:	00000097          	auipc	ra,0x0
  88:	6d2080e7          	jalr	1746(ra) # 756 <fprintf>
    exit(1);
  8c:	4505                	li	a0,1
  8e:	00000097          	auipc	ra,0x0
  92:	348080e7          	jalr	840(ra) # 3d6 <exit>

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
  c8:	352080e7          	jalr	850(ra) # 416 <open>
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
  e0:	322080e7          	jalr	802(ra) # 3fe <close>
  for(i = 1; i < argc; i++){
  e4:	0921                	addi	s2,s2,8
  e6:	fd391ce3          	bne	s2,s3,be <main+0x28>
  }
  exit(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	2ea080e7          	jalr	746(ra) # 3d6 <exit>
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
 10a:	2d0080e7          	jalr	720(ra) # 3d6 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 10e:	00093603          	ld	a2,0(s2)
 112:	00001597          	auipc	a1,0x1
 116:	aae58593          	addi	a1,a1,-1362 # bc0 <ithread_join+0x7e>
 11a:	4509                	li	a0,2
 11c:	00000097          	auipc	ra,0x0
 120:	63a080e7          	jalr	1594(ra) # 756 <fprintf>
      exit(1);
 124:	4505                	li	a0,1
 126:	00000097          	auipc	ra,0x0
 12a:	2b0080e7          	jalr	688(ra) # 3d6 <exit>

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
 144:	296080e7          	jalr	662(ra) # 3d6 <exit>

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
 1a4:	cf91                	beqz	a5,1c0 <strlen+0x28>
 1a6:	00150793          	addi	a5,a0,1
 1aa:	86be                	mv	a3,a5
 1ac:	0785                	addi	a5,a5,1
 1ae:	fff7c703          	lbu	a4,-1(a5)
 1b2:	ff65                	bnez	a4,1aa <strlen+0x12>
 1b4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1b8:	60a2                	ld	ra,8(sp)
 1ba:	6402                	ld	s0,0(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret
  for(n = 0; s[n]; n++)
 1c0:	4501                	li	a0,0
 1c2:	bfdd                	j	1b8 <strlen+0x20>

00000000000001c4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c4:	1141                	addi	sp,sp,-16
 1c6:	e406                	sd	ra,8(sp)
 1c8:	e022                	sd	s0,0(sp)
 1ca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1cc:	ca19                	beqz	a2,1e2 <memset+0x1e>
 1ce:	87aa                	mv	a5,a0
 1d0:	1602                	slli	a2,a2,0x20
 1d2:	9201                	srli	a2,a2,0x20
 1d4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1dc:	0785                	addi	a5,a5,1
 1de:	fee79de3          	bne	a5,a4,1d8 <memset+0x14>
  }
  return dst;
}
 1e2:	60a2                	ld	ra,8(sp)
 1e4:	6402                	ld	s0,0(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret

00000000000001ea <strchr>:

char*
strchr(const char *s, char c)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1f2:	00054783          	lbu	a5,0(a0)
 1f6:	cf81                	beqz	a5,20e <strchr+0x24>
    if(*s == c)
 1f8:	00f58763          	beq	a1,a5,206 <strchr+0x1c>
  for(; *s; s++)
 1fc:	0505                	addi	a0,a0,1
 1fe:	00054783          	lbu	a5,0(a0)
 202:	fbfd                	bnez	a5,1f8 <strchr+0xe>
      return (char*)s;
  return 0;
 204:	4501                	li	a0,0
}
 206:	60a2                	ld	ra,8(sp)
 208:	6402                	ld	s0,0(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret
  return 0;
 20e:	4501                	li	a0,0
 210:	bfdd                	j	206 <strchr+0x1c>

0000000000000212 <gets>:

char*
gets(char *buf, int max)
{
 212:	711d                	addi	sp,sp,-96
 214:	ec86                	sd	ra,88(sp)
 216:	e8a2                	sd	s0,80(sp)
 218:	e4a6                	sd	s1,72(sp)
 21a:	e0ca                	sd	s2,64(sp)
 21c:	fc4e                	sd	s3,56(sp)
 21e:	f852                	sd	s4,48(sp)
 220:	f456                	sd	s5,40(sp)
 222:	f05a                	sd	s6,32(sp)
 224:	ec5e                	sd	s7,24(sp)
 226:	e862                	sd	s8,16(sp)
 228:	1080                	addi	s0,sp,96
 22a:	8baa                	mv	s7,a0
 22c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22e:	892a                	mv	s2,a0
 230:	4481                	li	s1,0
    cc = read(0, &c, 1);
 232:	faf40b13          	addi	s6,s0,-81
 236:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 238:	8c26                	mv	s8,s1
 23a:	0014899b          	addiw	s3,s1,1
 23e:	84ce                	mv	s1,s3
 240:	0349d663          	bge	s3,s4,26c <gets+0x5a>
    cc = read(0, &c, 1);
 244:	8656                	mv	a2,s5
 246:	85da                	mv	a1,s6
 248:	4501                	li	a0,0
 24a:	00000097          	auipc	ra,0x0
 24e:	1a4080e7          	jalr	420(ra) # 3ee <read>
    if(cc < 1)
 252:	00a05d63          	blez	a0,26c <gets+0x5a>
      break;
    buf[i++] = c;
 256:	faf44783          	lbu	a5,-81(s0)
 25a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 25e:	0905                	addi	s2,s2,1
 260:	ff678713          	addi	a4,a5,-10
 264:	c319                	beqz	a4,26a <gets+0x58>
 266:	17cd                	addi	a5,a5,-13
 268:	fbe1                	bnez	a5,238 <gets+0x26>
    buf[i++] = c;
 26a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 26c:	9c5e                	add	s8,s8,s7
 26e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 272:	855e                	mv	a0,s7
 274:	60e6                	ld	ra,88(sp)
 276:	6446                	ld	s0,80(sp)
 278:	64a6                	ld	s1,72(sp)
 27a:	6906                	ld	s2,64(sp)
 27c:	79e2                	ld	s3,56(sp)
 27e:	7a42                	ld	s4,48(sp)
 280:	7aa2                	ld	s5,40(sp)
 282:	7b02                	ld	s6,32(sp)
 284:	6be2                	ld	s7,24(sp)
 286:	6c42                	ld	s8,16(sp)
 288:	6125                	addi	sp,sp,96
 28a:	8082                	ret

000000000000028c <stat>:

int
stat(const char *n, struct stat *st)
{
 28c:	1101                	addi	sp,sp,-32
 28e:	ec06                	sd	ra,24(sp)
 290:	e822                	sd	s0,16(sp)
 292:	e04a                	sd	s2,0(sp)
 294:	1000                	addi	s0,sp,32
 296:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 298:	4581                	li	a1,0
 29a:	00000097          	auipc	ra,0x0
 29e:	17c080e7          	jalr	380(ra) # 416 <open>
  if(fd < 0)
 2a2:	02054663          	bltz	a0,2ce <stat+0x42>
 2a6:	e426                	sd	s1,8(sp)
 2a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2aa:	85ca                	mv	a1,s2
 2ac:	00000097          	auipc	ra,0x0
 2b0:	182080e7          	jalr	386(ra) # 42e <fstat>
 2b4:	892a                	mv	s2,a0
  close(fd);
 2b6:	8526                	mv	a0,s1
 2b8:	00000097          	auipc	ra,0x0
 2bc:	146080e7          	jalr	326(ra) # 3fe <close>
  return r;
 2c0:	64a2                	ld	s1,8(sp)
}
 2c2:	854a                	mv	a0,s2
 2c4:	60e2                	ld	ra,24(sp)
 2c6:	6442                	ld	s0,16(sp)
 2c8:	6902                	ld	s2,0(sp)
 2ca:	6105                	addi	sp,sp,32
 2cc:	8082                	ret
    return -1;
 2ce:	57fd                	li	a5,-1
 2d0:	893e                	mv	s2,a5
 2d2:	bfc5                	j	2c2 <stat+0x36>

00000000000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e406                	sd	ra,8(sp)
 2d8:	e022                	sd	s0,0(sp)
 2da:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2dc:	00054683          	lbu	a3,0(a0)
 2e0:	fd06879b          	addiw	a5,a3,-48
 2e4:	0ff7f793          	zext.b	a5,a5
 2e8:	4625                	li	a2,9
 2ea:	02f66963          	bltu	a2,a5,31c <atoi+0x48>
 2ee:	872a                	mv	a4,a0
  n = 0;
 2f0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2f2:	0705                	addi	a4,a4,1
 2f4:	0025179b          	slliw	a5,a0,0x2
 2f8:	9fa9                	addw	a5,a5,a0
 2fa:	0017979b          	slliw	a5,a5,0x1
 2fe:	9fb5                	addw	a5,a5,a3
 300:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 304:	00074683          	lbu	a3,0(a4)
 308:	fd06879b          	addiw	a5,a3,-48
 30c:	0ff7f793          	zext.b	a5,a5
 310:	fef671e3          	bgeu	a2,a5,2f2 <atoi+0x1e>
  return n;
}
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret
  n = 0;
 31c:	4501                	li	a0,0
 31e:	bfdd                	j	314 <atoi+0x40>

0000000000000320 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 328:	02b57563          	bgeu	a0,a1,352 <memmove+0x32>
    while(n-- > 0)
 32c:	00c05f63          	blez	a2,34a <memmove+0x2a>
 330:	1602                	slli	a2,a2,0x20
 332:	9201                	srli	a2,a2,0x20
 334:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 338:	872a                	mv	a4,a0
      *dst++ = *src++;
 33a:	0585                	addi	a1,a1,1
 33c:	0705                	addi	a4,a4,1
 33e:	fff5c683          	lbu	a3,-1(a1)
 342:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 346:	fee79ae3          	bne	a5,a4,33a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
    while(n-- > 0)
 352:	fec05ce3          	blez	a2,34a <memmove+0x2a>
    dst += n;
 356:	00c50733          	add	a4,a0,a2
    src += n;
 35a:	95b2                	add	a1,a1,a2
 35c:	fff6079b          	addiw	a5,a2,-1
 360:	1782                	slli	a5,a5,0x20
 362:	9381                	srli	a5,a5,0x20
 364:	fff7c793          	not	a5,a5
 368:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 36a:	15fd                	addi	a1,a1,-1
 36c:	177d                	addi	a4,a4,-1
 36e:	0005c683          	lbu	a3,0(a1)
 372:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 376:	fef71ae3          	bne	a4,a5,36a <memmove+0x4a>
 37a:	bfc1                	j	34a <memmove+0x2a>

000000000000037c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e406                	sd	ra,8(sp)
 380:	e022                	sd	s0,0(sp)
 382:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 384:	c61d                	beqz	a2,3b2 <memcmp+0x36>
 386:	1602                	slli	a2,a2,0x20
 388:	9201                	srli	a2,a2,0x20
 38a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 38e:	00054783          	lbu	a5,0(a0)
 392:	0005c703          	lbu	a4,0(a1)
 396:	00e79863          	bne	a5,a4,3a6 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 39a:	0505                	addi	a0,a0,1
    p2++;
 39c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 39e:	fed518e3          	bne	a0,a3,38e <memcmp+0x12>
  }
  return 0;
 3a2:	4501                	li	a0,0
 3a4:	a019                	j	3aa <memcmp+0x2e>
      return *p1 - *p2;
 3a6:	40e7853b          	subw	a0,a5,a4
}
 3aa:	60a2                	ld	ra,8(sp)
 3ac:	6402                	ld	s0,0(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret
  return 0;
 3b2:	4501                	li	a0,0
 3b4:	bfdd                	j	3aa <memcmp+0x2e>

00000000000003b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e406                	sd	ra,8(sp)
 3ba:	e022                	sd	s0,0(sp)
 3bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3be:	00000097          	auipc	ra,0x0
 3c2:	f62080e7          	jalr	-158(ra) # 320 <memmove>
}
 3c6:	60a2                	ld	ra,8(sp)
 3c8:	6402                	ld	s0,0(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret

00000000000003ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ce:	4885                	li	a7,1
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d6:	4889                	li	a7,2
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <wait>:
.global wait
wait:
 li a7, SYS_wait
 3de:	488d                	li	a7,3
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e6:	4891                	li	a7,4
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <read>:
.global read
read:
 li a7, SYS_read
 3ee:	4895                	li	a7,5
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <write>:
.global write
write:
 li a7, SYS_write
 3f6:	48c1                	li	a7,16
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <close>:
.global close
close:
 li a7, SYS_close
 3fe:	48d5                	li	a7,21
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <kill>:
.global kill
kill:
 li a7, SYS_kill
 406:	4899                	li	a7,6
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <exec>:
.global exec
exec:
 li a7, SYS_exec
 40e:	489d                	li	a7,7
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <open>:
.global open
open:
 li a7, SYS_open
 416:	48bd                	li	a7,15
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 41e:	48c5                	li	a7,17
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 426:	48c9                	li	a7,18
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 42e:	48a1                	li	a7,8
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <link>:
.global link
link:
 li a7, SYS_link
 436:	48cd                	li	a7,19
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 43e:	48d1                	li	a7,20
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 446:	48a5                	li	a7,9
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <dup>:
.global dup
dup:
 li a7, SYS_dup
 44e:	48a9                	li	a7,10
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 456:	48ad                	li	a7,11
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 45e:	48b1                	li	a7,12
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 466:	48b5                	li	a7,13
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 46e:	48b9                	li	a7,14
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 476:	48d9                	li	a7,22
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 47e:	48dd                	li	a7,23
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 486:	48e1                	li	a7,24
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 48e:	48e5                	li	a7,25
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <socket>:
.global socket
socket:
 li a7, SYS_socket
 496:	48e9                	li	a7,26
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <bind>:
.global bind
bind:
 li a7, SYS_bind
 49e:	48ed                	li	a7,27
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <accept>:
.global accept
accept:
 li a7, SYS_accept
 4a6:	48f5                	li	a7,29
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <listen>:
.global listen
listen:
 li a7, SYS_listen
 4ae:	48f1                	li	a7,28
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <connect>:
.global connect
connect:
 li a7, SYS_connect
 4b6:	48f9                	li	a7,30
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4be:	1101                	addi	sp,sp,-32
 4c0:	ec06                	sd	ra,24(sp)
 4c2:	e822                	sd	s0,16(sp)
 4c4:	1000                	addi	s0,sp,32
 4c6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ca:	4605                	li	a2,1
 4cc:	fef40593          	addi	a1,s0,-17
 4d0:	00000097          	auipc	ra,0x0
 4d4:	f26080e7          	jalr	-218(ra) # 3f6 <write>
}
 4d8:	60e2                	ld	ra,24(sp)
 4da:	6442                	ld	s0,16(sp)
 4dc:	6105                	addi	sp,sp,32
 4de:	8082                	ret

00000000000004e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e0:	7139                	addi	sp,sp,-64
 4e2:	fc06                	sd	ra,56(sp)
 4e4:	f822                	sd	s0,48(sp)
 4e6:	f04a                	sd	s2,32(sp)
 4e8:	ec4e                	sd	s3,24(sp)
 4ea:	0080                	addi	s0,sp,64
 4ec:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ee:	cad9                	beqz	a3,584 <printint+0xa4>
 4f0:	01f5d79b          	srliw	a5,a1,0x1f
 4f4:	cbc1                	beqz	a5,584 <printint+0xa4>
    neg = 1;
    x = -xx;
 4f6:	40b005bb          	negw	a1,a1
    neg = 1;
 4fa:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4fc:	fc040993          	addi	s3,s0,-64
  neg = 0;
 500:	86ce                	mv	a3,s3
  i = 0;
 502:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 504:	00000817          	auipc	a6,0x0
 508:	76480813          	addi	a6,a6,1892 # c68 <digits>
 50c:	88ba                	mv	a7,a4
 50e:	0017051b          	addiw	a0,a4,1
 512:	872a                	mv	a4,a0
 514:	02c5f7bb          	remuw	a5,a1,a2
 518:	1782                	slli	a5,a5,0x20
 51a:	9381                	srli	a5,a5,0x20
 51c:	97c2                	add	a5,a5,a6
 51e:	0007c783          	lbu	a5,0(a5)
 522:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 526:	87ae                	mv	a5,a1
 528:	02c5d5bb          	divuw	a1,a1,a2
 52c:	0685                	addi	a3,a3,1
 52e:	fcc7ffe3          	bgeu	a5,a2,50c <printint+0x2c>
  if(neg)
 532:	00030c63          	beqz	t1,54a <printint+0x6a>
    buf[i++] = '-';
 536:	fd050793          	addi	a5,a0,-48
 53a:	00878533          	add	a0,a5,s0
 53e:	02d00793          	li	a5,45
 542:	fef50823          	sb	a5,-16(a0)
 546:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 54a:	02e05763          	blez	a4,578 <printint+0x98>
 54e:	f426                	sd	s1,40(sp)
 550:	377d                	addiw	a4,a4,-1
 552:	00e984b3          	add	s1,s3,a4
 556:	19fd                	addi	s3,s3,-1
 558:	99ba                	add	s3,s3,a4
 55a:	1702                	slli	a4,a4,0x20
 55c:	9301                	srli	a4,a4,0x20
 55e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 562:	0004c583          	lbu	a1,0(s1)
 566:	854a                	mv	a0,s2
 568:	00000097          	auipc	ra,0x0
 56c:	f56080e7          	jalr	-170(ra) # 4be <putc>
  while(--i >= 0)
 570:	14fd                	addi	s1,s1,-1
 572:	ff3498e3          	bne	s1,s3,562 <printint+0x82>
 576:	74a2                	ld	s1,40(sp)
}
 578:	70e2                	ld	ra,56(sp)
 57a:	7442                	ld	s0,48(sp)
 57c:	7902                	ld	s2,32(sp)
 57e:	69e2                	ld	s3,24(sp)
 580:	6121                	addi	sp,sp,64
 582:	8082                	ret
  neg = 0;
 584:	4301                	li	t1,0
 586:	bf9d                	j	4fc <printint+0x1c>

0000000000000588 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 588:	715d                	addi	sp,sp,-80
 58a:	e486                	sd	ra,72(sp)
 58c:	e0a2                	sd	s0,64(sp)
 58e:	f84a                	sd	s2,48(sp)
 590:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 592:	0005c903          	lbu	s2,0(a1)
 596:	1a090b63          	beqz	s2,74c <vprintf+0x1c4>
 59a:	fc26                	sd	s1,56(sp)
 59c:	f44e                	sd	s3,40(sp)
 59e:	f052                	sd	s4,32(sp)
 5a0:	ec56                	sd	s5,24(sp)
 5a2:	e85a                	sd	s6,16(sp)
 5a4:	e45e                	sd	s7,8(sp)
 5a6:	8aaa                	mv	s5,a0
 5a8:	8bb2                	mv	s7,a2
 5aa:	00158493          	addi	s1,a1,1
  state = 0;
 5ae:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5b0:	02500a13          	li	s4,37
 5b4:	4b55                	li	s6,21
 5b6:	a839                	j	5d4 <vprintf+0x4c>
        putc(fd, c);
 5b8:	85ca                	mv	a1,s2
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	f02080e7          	jalr	-254(ra) # 4be <putc>
 5c4:	a019                	j	5ca <vprintf+0x42>
    } else if(state == '%'){
 5c6:	01498d63          	beq	s3,s4,5e0 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5ca:	0485                	addi	s1,s1,1
 5cc:	fff4c903          	lbu	s2,-1(s1)
 5d0:	16090863          	beqz	s2,740 <vprintf+0x1b8>
    if(state == 0){
 5d4:	fe0999e3          	bnez	s3,5c6 <vprintf+0x3e>
      if(c == '%'){
 5d8:	ff4910e3          	bne	s2,s4,5b8 <vprintf+0x30>
        state = '%';
 5dc:	89d2                	mv	s3,s4
 5de:	b7f5                	j	5ca <vprintf+0x42>
      if(c == 'd'){
 5e0:	13490563          	beq	s2,s4,70a <vprintf+0x182>
 5e4:	f9d9079b          	addiw	a5,s2,-99
 5e8:	0ff7f793          	zext.b	a5,a5
 5ec:	12fb6863          	bltu	s6,a5,71c <vprintf+0x194>
 5f0:	f9d9079b          	addiw	a5,s2,-99
 5f4:	0ff7f713          	zext.b	a4,a5
 5f8:	12eb6263          	bltu	s6,a4,71c <vprintf+0x194>
 5fc:	00271793          	slli	a5,a4,0x2
 600:	00000717          	auipc	a4,0x0
 604:	61070713          	addi	a4,a4,1552 # c10 <ithread_join+0xce>
 608:	97ba                	add	a5,a5,a4
 60a:	439c                	lw	a5,0(a5)
 60c:	97ba                	add	a5,a5,a4
 60e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 610:	008b8913          	addi	s2,s7,8
 614:	4685                	li	a3,1
 616:	4629                	li	a2,10
 618:	000ba583          	lw	a1,0(s7)
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	ec2080e7          	jalr	-318(ra) # 4e0 <printint>
 626:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 628:	4981                	li	s3,0
 62a:	b745                	j	5ca <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62c:	008b8913          	addi	s2,s7,8
 630:	4681                	li	a3,0
 632:	4629                	li	a2,10
 634:	000ba583          	lw	a1,0(s7)
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	ea6080e7          	jalr	-346(ra) # 4e0 <printint>
 642:	8bca                	mv	s7,s2
      state = 0;
 644:	4981                	li	s3,0
 646:	b751                	j	5ca <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 648:	008b8913          	addi	s2,s7,8
 64c:	4681                	li	a3,0
 64e:	4641                	li	a2,16
 650:	000ba583          	lw	a1,0(s7)
 654:	8556                	mv	a0,s5
 656:	00000097          	auipc	ra,0x0
 65a:	e8a080e7          	jalr	-374(ra) # 4e0 <printint>
 65e:	8bca                	mv	s7,s2
      state = 0;
 660:	4981                	li	s3,0
 662:	b7a5                	j	5ca <vprintf+0x42>
 664:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 666:	008b8793          	addi	a5,s7,8
 66a:	8c3e                	mv	s8,a5
 66c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 670:	03000593          	li	a1,48
 674:	8556                	mv	a0,s5
 676:	00000097          	auipc	ra,0x0
 67a:	e48080e7          	jalr	-440(ra) # 4be <putc>
  putc(fd, 'x');
 67e:	07800593          	li	a1,120
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e3a080e7          	jalr	-454(ra) # 4be <putc>
 68c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68e:	00000b97          	auipc	s7,0x0
 692:	5dab8b93          	addi	s7,s7,1498 # c68 <digits>
 696:	03c9d793          	srli	a5,s3,0x3c
 69a:	97de                	add	a5,a5,s7
 69c:	0007c583          	lbu	a1,0(a5)
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	e1c080e7          	jalr	-484(ra) # 4be <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6aa:	0992                	slli	s3,s3,0x4
 6ac:	397d                	addiw	s2,s2,-1
 6ae:	fe0914e3          	bnez	s2,696 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 6b2:	8be2                	mv	s7,s8
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	6c02                	ld	s8,0(sp)
 6b8:	bf09                	j	5ca <vprintf+0x42>
        s = va_arg(ap, char*);
 6ba:	008b8993          	addi	s3,s7,8
 6be:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6c2:	02090163          	beqz	s2,6e4 <vprintf+0x15c>
        while(*s != 0){
 6c6:	00094583          	lbu	a1,0(s2)
 6ca:	c9a5                	beqz	a1,73a <vprintf+0x1b2>
          putc(fd, *s);
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	df0080e7          	jalr	-528(ra) # 4be <putc>
          s++;
 6d6:	0905                	addi	s2,s2,1
        while(*s != 0){
 6d8:	00094583          	lbu	a1,0(s2)
 6dc:	f9e5                	bnez	a1,6cc <vprintf+0x144>
        s = va_arg(ap, char*);
 6de:	8bce                	mv	s7,s3
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b5e5                	j	5ca <vprintf+0x42>
          s = "(null)";
 6e4:	00000917          	auipc	s2,0x0
 6e8:	4f490913          	addi	s2,s2,1268 # bd8 <ithread_join+0x96>
        while(*s != 0){
 6ec:	02800593          	li	a1,40
 6f0:	bff1                	j	6cc <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	000bc583          	lbu	a1,0(s7)
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	dc2080e7          	jalr	-574(ra) # 4be <putc>
 704:	8bca                	mv	s7,s2
      state = 0;
 706:	4981                	li	s3,0
 708:	b5c9                	j	5ca <vprintf+0x42>
        putc(fd, c);
 70a:	02500593          	li	a1,37
 70e:	8556                	mv	a0,s5
 710:	00000097          	auipc	ra,0x0
 714:	dae080e7          	jalr	-594(ra) # 4be <putc>
      state = 0;
 718:	4981                	li	s3,0
 71a:	bd45                	j	5ca <vprintf+0x42>
        putc(fd, '%');
 71c:	02500593          	li	a1,37
 720:	8556                	mv	a0,s5
 722:	00000097          	auipc	ra,0x0
 726:	d9c080e7          	jalr	-612(ra) # 4be <putc>
        putc(fd, c);
 72a:	85ca                	mv	a1,s2
 72c:	8556                	mv	a0,s5
 72e:	00000097          	auipc	ra,0x0
 732:	d90080e7          	jalr	-624(ra) # 4be <putc>
      state = 0;
 736:	4981                	li	s3,0
 738:	bd49                	j	5ca <vprintf+0x42>
        s = va_arg(ap, char*);
 73a:	8bce                	mv	s7,s3
      state = 0;
 73c:	4981                	li	s3,0
 73e:	b571                	j	5ca <vprintf+0x42>
 740:	74e2                	ld	s1,56(sp)
 742:	79a2                	ld	s3,40(sp)
 744:	7a02                	ld	s4,32(sp)
 746:	6ae2                	ld	s5,24(sp)
 748:	6b42                	ld	s6,16(sp)
 74a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 74c:	60a6                	ld	ra,72(sp)
 74e:	6406                	ld	s0,64(sp)
 750:	7942                	ld	s2,48(sp)
 752:	6161                	addi	sp,sp,80
 754:	8082                	ret

0000000000000756 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 756:	715d                	addi	sp,sp,-80
 758:	ec06                	sd	ra,24(sp)
 75a:	e822                	sd	s0,16(sp)
 75c:	1000                	addi	s0,sp,32
 75e:	e010                	sd	a2,0(s0)
 760:	e414                	sd	a3,8(s0)
 762:	e818                	sd	a4,16(s0)
 764:	ec1c                	sd	a5,24(s0)
 766:	03043023          	sd	a6,32(s0)
 76a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 76e:	8622                	mv	a2,s0
 770:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 774:	00000097          	auipc	ra,0x0
 778:	e14080e7          	jalr	-492(ra) # 588 <vprintf>
}
 77c:	60e2                	ld	ra,24(sp)
 77e:	6442                	ld	s0,16(sp)
 780:	6161                	addi	sp,sp,80
 782:	8082                	ret

0000000000000784 <printf>:

void
printf(const char *fmt, ...)
{
 784:	711d                	addi	sp,sp,-96
 786:	ec06                	sd	ra,24(sp)
 788:	e822                	sd	s0,16(sp)
 78a:	1000                	addi	s0,sp,32
 78c:	e40c                	sd	a1,8(s0)
 78e:	e810                	sd	a2,16(s0)
 790:	ec14                	sd	a3,24(s0)
 792:	f018                	sd	a4,32(s0)
 794:	f41c                	sd	a5,40(s0)
 796:	03043823          	sd	a6,48(s0)
 79a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 79e:	00840613          	addi	a2,s0,8
 7a2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a6:	85aa                	mv	a1,a0
 7a8:	4505                	li	a0,1
 7aa:	00000097          	auipc	ra,0x0
 7ae:	dde080e7          	jalr	-546(ra) # 588 <vprintf>
}
 7b2:	60e2                	ld	ra,24(sp)
 7b4:	6442                	ld	s0,16(sp)
 7b6:	6125                	addi	sp,sp,96
 7b8:	8082                	ret

00000000000007ba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ba:	1141                	addi	sp,sp,-16
 7bc:	e406                	sd	ra,8(sp)
 7be:	e022                	sd	s0,0(sp)
 7c0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	00001797          	auipc	a5,0x1
 7ca:	d9a7b783          	ld	a5,-614(a5) # 1560 <freep>
 7ce:	a039                	j	7dc <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d0:	6398                	ld	a4,0(a5)
 7d2:	00e7e463          	bltu	a5,a4,7da <free+0x20>
 7d6:	00e6ea63          	bltu	a3,a4,7ea <free+0x30>
{
 7da:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dc:	fed7fae3          	bgeu	a5,a3,7d0 <free+0x16>
 7e0:	6398                	ld	a4,0(a5)
 7e2:	00e6e463          	bltu	a3,a4,7ea <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e6:	fee7eae3          	bltu	a5,a4,7da <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ea:	ff852583          	lw	a1,-8(a0)
 7ee:	6390                	ld	a2,0(a5)
 7f0:	02059813          	slli	a6,a1,0x20
 7f4:	01c85713          	srli	a4,a6,0x1c
 7f8:	9736                	add	a4,a4,a3
 7fa:	02e60563          	beq	a2,a4,824 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7fe:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 802:	4790                	lw	a2,8(a5)
 804:	02061593          	slli	a1,a2,0x20
 808:	01c5d713          	srli	a4,a1,0x1c
 80c:	973e                	add	a4,a4,a5
 80e:	02e68263          	beq	a3,a4,832 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 812:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 814:	00001717          	auipc	a4,0x1
 818:	d4f73623          	sd	a5,-692(a4) # 1560 <freep>
}
 81c:	60a2                	ld	ra,8(sp)
 81e:	6402                	ld	s0,0(sp)
 820:	0141                	addi	sp,sp,16
 822:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 824:	4618                	lw	a4,8(a2)
 826:	9f2d                	addw	a4,a4,a1
 828:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 82c:	6398                	ld	a4,0(a5)
 82e:	6310                	ld	a2,0(a4)
 830:	b7f9                	j	7fe <free+0x44>
    p->s.size += bp->s.size;
 832:	ff852703          	lw	a4,-8(a0)
 836:	9f31                	addw	a4,a4,a2
 838:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 83a:	ff053683          	ld	a3,-16(a0)
 83e:	bfd1                	j	812 <free+0x58>

0000000000000840 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 840:	7139                	addi	sp,sp,-64
 842:	fc06                	sd	ra,56(sp)
 844:	f822                	sd	s0,48(sp)
 846:	f04a                	sd	s2,32(sp)
 848:	ec4e                	sd	s3,24(sp)
 84a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84c:	02051993          	slli	s3,a0,0x20
 850:	0209d993          	srli	s3,s3,0x20
 854:	09bd                	addi	s3,s3,15
 856:	0049d993          	srli	s3,s3,0x4
 85a:	2985                	addiw	s3,s3,1
 85c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 85e:	00001517          	auipc	a0,0x1
 862:	d0253503          	ld	a0,-766(a0) # 1560 <freep>
 866:	c905                	beqz	a0,896 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86a:	4798                	lw	a4,8(a5)
 86c:	09377a63          	bgeu	a4,s3,900 <malloc+0xc0>
 870:	f426                	sd	s1,40(sp)
 872:	e852                	sd	s4,16(sp)
 874:	e456                	sd	s5,8(sp)
 876:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 878:	8a4e                	mv	s4,s3
 87a:	6705                	lui	a4,0x1
 87c:	00e9f363          	bgeu	s3,a4,882 <malloc+0x42>
 880:	6a05                	lui	s4,0x1
 882:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 886:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 88a:	00001497          	auipc	s1,0x1
 88e:	cd648493          	addi	s1,s1,-810 # 1560 <freep>
  if(p == (char*)-1)
 892:	5afd                	li	s5,-1
 894:	a089                	j	8d6 <malloc+0x96>
 896:	f426                	sd	s1,40(sp)
 898:	e852                	sd	s4,16(sp)
 89a:	e456                	sd	s5,8(sp)
 89c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 89e:	00001797          	auipc	a5,0x1
 8a2:	ee278793          	addi	a5,a5,-286 # 1780 <base>
 8a6:	00001717          	auipc	a4,0x1
 8aa:	caf73d23          	sd	a5,-838(a4) # 1560 <freep>
 8ae:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b4:	b7d1                	j	878 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8b6:	6398                	ld	a4,0(a5)
 8b8:	e118                	sd	a4,0(a0)
 8ba:	a8b9                	j	918 <malloc+0xd8>
  hp->s.size = nu;
 8bc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c0:	0541                	addi	a0,a0,16
 8c2:	00000097          	auipc	ra,0x0
 8c6:	ef8080e7          	jalr	-264(ra) # 7ba <free>
  return freep;
 8ca:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8cc:	c135                	beqz	a0,930 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d0:	4798                	lw	a4,8(a5)
 8d2:	03277363          	bgeu	a4,s2,8f8 <malloc+0xb8>
    if(p == freep)
 8d6:	6098                	ld	a4,0(s1)
 8d8:	853e                	mv	a0,a5
 8da:	fef71ae3          	bne	a4,a5,8ce <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8de:	8552                	mv	a0,s4
 8e0:	00000097          	auipc	ra,0x0
 8e4:	b7e080e7          	jalr	-1154(ra) # 45e <sbrk>
  if(p == (char*)-1)
 8e8:	fd551ae3          	bne	a0,s5,8bc <malloc+0x7c>
        return 0;
 8ec:	4501                	li	a0,0
 8ee:	74a2                	ld	s1,40(sp)
 8f0:	6a42                	ld	s4,16(sp)
 8f2:	6aa2                	ld	s5,8(sp)
 8f4:	6b02                	ld	s6,0(sp)
 8f6:	a03d                	j	924 <malloc+0xe4>
 8f8:	74a2                	ld	s1,40(sp)
 8fa:	6a42                	ld	s4,16(sp)
 8fc:	6aa2                	ld	s5,8(sp)
 8fe:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 900:	fae90be3          	beq	s2,a4,8b6 <malloc+0x76>
        p->s.size -= nunits;
 904:	4137073b          	subw	a4,a4,s3
 908:	c798                	sw	a4,8(a5)
        p += p->s.size;
 90a:	02071693          	slli	a3,a4,0x20
 90e:	01c6d713          	srli	a4,a3,0x1c
 912:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 914:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 918:	00001717          	auipc	a4,0x1
 91c:	c4a73423          	sd	a0,-952(a4) # 1560 <freep>
      return (void*)(p + 1);
 920:	01078513          	addi	a0,a5,16
  }
}
 924:	70e2                	ld	ra,56(sp)
 926:	7442                	ld	s0,48(sp)
 928:	7902                	ld	s2,32(sp)
 92a:	69e2                	ld	s3,24(sp)
 92c:	6121                	addi	sp,sp,64
 92e:	8082                	ret
 930:	74a2                	ld	s1,40(sp)
 932:	6a42                	ld	s4,16(sp)
 934:	6aa2                	ld	s5,8(sp)
 936:	6b02                	ld	s6,0(sp)
 938:	b7f5                	j	924 <malloc+0xe4>

000000000000093a <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 93a:	1141                	addi	sp,sp,-16
 93c:	e406                	sd	ra,8(sp)
 93e:	e022                	sd	s0,0(sp)
 940:	0800                	addi	s0,sp,16
  thread_exit(status);
 942:	2501                	sext.w	a0,a0
 944:	00000097          	auipc	ra,0x0
 948:	b4a080e7          	jalr	-1206(ra) # 48e <thread_exit>
}
 94c:	60a2                	ld	ra,8(sp)
 94e:	6402                	ld	s0,0(sp)
 950:	0141                	addi	sp,sp,16
 952:	8082                	ret

0000000000000954 <free_stacks>:
int free_stacks() {
 954:	7179                	addi	sp,sp,-48
 956:	f406                	sd	ra,40(sp)
 958:	f022                	sd	s0,32(sp)
 95a:	ec26                	sd	s1,24(sp)
 95c:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 95e:	00001797          	auipc	a5,0x1
 962:	c127a783          	lw	a5,-1006(a5) # 1570 <num_threads>
 966:	04f05063          	blez	a5,9a6 <free_stacks+0x52>
 96a:	e84a                	sd	s2,16(sp)
 96c:	e44e                	sd	s3,8(sp)
 96e:	4481                	li	s1,0
    free(stacks[i]);
 970:	00001997          	auipc	s3,0x1
 974:	bf898993          	addi	s3,s3,-1032 # 1568 <stacks>
  for (int i = 0; i < num_threads; i++) {
 978:	00001917          	auipc	s2,0x1
 97c:	bf890913          	addi	s2,s2,-1032 # 1570 <num_threads>
    free(stacks[i]);
 980:	0009b783          	ld	a5,0(s3)
 984:	00349713          	slli	a4,s1,0x3
 988:	97ba                	add	a5,a5,a4
 98a:	6388                	ld	a0,0(a5)
 98c:	00000097          	auipc	ra,0x0
 990:	e2e080e7          	jalr	-466(ra) # 7ba <free>
  for (int i = 0; i < num_threads; i++) {
 994:	0485                	addi	s1,s1,1
 996:	00092703          	lw	a4,0(s2)
 99a:	0004879b          	sext.w	a5,s1
 99e:	fee7c1e3          	blt	a5,a4,980 <free_stacks+0x2c>
 9a2:	6942                	ld	s2,16(sp)
 9a4:	69a2                	ld	s3,8(sp)
  free(stacks);
 9a6:	00001497          	auipc	s1,0x1
 9aa:	bc248493          	addi	s1,s1,-1086 # 1568 <stacks>
 9ae:	6088                	ld	a0,0(s1)
 9b0:	00000097          	auipc	ra,0x0
 9b4:	e0a080e7          	jalr	-502(ra) # 7ba <free>
  stacks = 0;
 9b8:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 9bc:	00001797          	auipc	a5,0x1
 9c0:	ba07aa23          	sw	zero,-1100(a5) # 1570 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 9c4:	47a1                	li	a5,8
 9c6:	00001717          	auipc	a4,0x1
 9ca:	b8f72523          	sw	a5,-1142(a4) # 1550 <max_stacks>
  threads_done = 0;
 9ce:	00001797          	auipc	a5,0x1
 9d2:	ba07a323          	sw	zero,-1114(a5) # 1574 <threads_done>
}
 9d6:	4501                	li	a0,0
 9d8:	70a2                	ld	ra,40(sp)
 9da:	7402                	ld	s0,32(sp)
 9dc:	64e2                	ld	s1,24(sp)
 9de:	6145                	addi	sp,sp,48
 9e0:	8082                	ret

00000000000009e2 <expand_num_threads>:
int expand_num_threads() {
 9e2:	1101                	addi	sp,sp,-32
 9e4:	ec06                	sd	ra,24(sp)
 9e6:	e822                	sd	s0,16(sp)
 9e8:	e426                	sd	s1,8(sp)
 9ea:	e04a                	sd	s2,0(sp)
 9ec:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 9ee:	00001797          	auipc	a5,0x1
 9f2:	b6278793          	addi	a5,a5,-1182 # 1550 <max_stacks>
 9f6:	4388                	lw	a0,0(a5)
 9f8:	0015151b          	slliw	a0,a0,0x1
 9fc:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 9fe:	0035151b          	slliw	a0,a0,0x3
 a02:	00000097          	auipc	ra,0x0
 a06:	e3e080e7          	jalr	-450(ra) # 840 <malloc>
 a0a:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a0c:	00001617          	auipc	a2,0x1
 a10:	b6462603          	lw	a2,-1180(a2) # 1570 <num_threads>
 a14:	00001497          	auipc	s1,0x1
 a18:	b5448493          	addi	s1,s1,-1196 # 1568 <stacks>
 a1c:	0036161b          	slliw	a2,a2,0x3
 a20:	608c                	ld	a1,0(s1)
 a22:	00000097          	auipc	ra,0x0
 a26:	8fe080e7          	jalr	-1794(ra) # 320 <memmove>
  free(stacks);
 a2a:	6088                	ld	a0,0(s1)
 a2c:	00000097          	auipc	ra,0x0
 a30:	d8e080e7          	jalr	-626(ra) # 7ba <free>
  stacks = new_stacks;
 a34:	0124b023          	sd	s2,0(s1)
}
 a38:	4501                	li	a0,0
 a3a:	60e2                	ld	ra,24(sp)
 a3c:	6442                	ld	s0,16(sp)
 a3e:	64a2                	ld	s1,8(sp)
 a40:	6902                	ld	s2,0(sp)
 a42:	6105                	addi	sp,sp,32
 a44:	8082                	ret

0000000000000a46 <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 a46:	7179                	addi	sp,sp,-48
 a48:	f406                	sd	ra,40(sp)
 a4a:	f022                	sd	s0,32(sp)
 a4c:	e84a                	sd	s2,16(sp)
 a4e:	e44e                	sd	s3,8(sp)
 a50:	1800                	addi	s0,sp,48
 a52:	892a                	mv	s2,a0
 a54:	89ae                	mv	s3,a1
  if (stacks == 0) {
 a56:	00001797          	auipc	a5,0x1
 a5a:	b127b783          	ld	a5,-1262(a5) # 1568 <stacks>
 a5e:	c3d9                	beqz	a5,ae4 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 a60:	00001797          	auipc	a5,0x1
 a64:	af07a783          	lw	a5,-1296(a5) # 1550 <max_stacks>
 a68:	00001717          	auipc	a4,0x1
 a6c:	b0872703          	lw	a4,-1272(a4) # 1570 <num_threads>
 a70:	0af71463          	bne	a4,a5,b18 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 a74:	04000713          	li	a4,64
 a78:	08e78563          	beq	a5,a4,b02 <ithread_create+0xbc>
 a7c:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 a7e:	00000097          	auipc	ra,0x0
 a82:	f64080e7          	jalr	-156(ra) # 9e2 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 a86:	6505                	lui	a0,0x1
 a88:	00000097          	auipc	ra,0x0
 a8c:	db8080e7          	jalr	-584(ra) # 840 <malloc>
 a90:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 a92:	00001717          	auipc	a4,0x1
 a96:	ade72703          	lw	a4,-1314(a4) # 1570 <num_threads>
 a9a:	070e                	slli	a4,a4,0x3
 a9c:	00001797          	auipc	a5,0x1
 aa0:	acc7b783          	ld	a5,-1332(a5) # 1568 <stacks>
 aa4:	97ba                	add	a5,a5,a4
 aa6:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 aa8:	00000697          	auipc	a3,0x0
 aac:	e9268693          	addi	a3,a3,-366 # 93a <ithread_exit>
 ab0:	862a                	mv	a2,a0
 ab2:	85ce                	mv	a1,s3
 ab4:	854a                	mv	a0,s2
 ab6:	00000097          	auipc	ra,0x0
 aba:	9c8080e7          	jalr	-1592(ra) # 47e <create_thread>
 abe:	892a                	mv	s2,a0
  if (res != -1) {
 ac0:	57fd                	li	a5,-1
 ac2:	04f50d63          	beq	a0,a5,b1c <ithread_create+0xd6>
    num_threads++;
 ac6:	00001717          	auipc	a4,0x1
 aca:	aaa70713          	addi	a4,a4,-1366 # 1570 <num_threads>
 ace:	431c                	lw	a5,0(a4)
 ad0:	2785                	addiw	a5,a5,1
 ad2:	c31c                	sw	a5,0(a4)
 ad4:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 ad6:	854a                	mv	a0,s2
 ad8:	70a2                	ld	ra,40(sp)
 ada:	7402                	ld	s0,32(sp)
 adc:	6942                	ld	s2,16(sp)
 ade:	69a2                	ld	s3,8(sp)
 ae0:	6145                	addi	sp,sp,48
 ae2:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 ae4:	00001517          	auipc	a0,0x1
 ae8:	a6c52503          	lw	a0,-1428(a0) # 1550 <max_stacks>
 aec:	0035151b          	slliw	a0,a0,0x3
 af0:	00000097          	auipc	ra,0x0
 af4:	d50080e7          	jalr	-688(ra) # 840 <malloc>
 af8:	00001797          	auipc	a5,0x1
 afc:	a6a7b823          	sd	a0,-1424(a5) # 1568 <stacks>
 b00:	b785                	j	a60 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b02:	00000517          	auipc	a0,0x0
 b06:	0de50513          	addi	a0,a0,222 # be0 <ithread_join+0x9e>
 b0a:	00000097          	auipc	ra,0x0
 b0e:	c7a080e7          	jalr	-902(ra) # 784 <printf>
      return -1;
 b12:	57fd                	li	a5,-1
 b14:	893e                	mv	s2,a5
 b16:	b7c1                	j	ad6 <ithread_create+0x90>
 b18:	ec26                	sd	s1,24(sp)
 b1a:	b7b5                	j	a86 <ithread_create+0x40>
    free(stack_ptr);
 b1c:	8526                	mv	a0,s1
 b1e:	00000097          	auipc	ra,0x0
 b22:	c9c080e7          	jalr	-868(ra) # 7ba <free>
    stacks[num_threads] = 0;
 b26:	00001717          	auipc	a4,0x1
 b2a:	a4a72703          	lw	a4,-1462(a4) # 1570 <num_threads>
 b2e:	070e                	slli	a4,a4,0x3
 b30:	00001797          	auipc	a5,0x1
 b34:	a387b783          	ld	a5,-1480(a5) # 1568 <stacks>
 b38:	97ba                	add	a5,a5,a4
 b3a:	0007b023          	sd	zero,0(a5)
 b3e:	64e2                	ld	s1,24(sp)
 b40:	bf59                	j	ad6 <ithread_create+0x90>

0000000000000b42 <ithread_join>:

int ithread_join(int thread_id) {
 b42:	1101                	addi	sp,sp,-32
 b44:	ec06                	sd	ra,24(sp)
 b46:	e822                	sd	s0,16(sp)
 b48:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 b4a:	ff040793          	addi	a5,s0,-16
 b4e:	ffc7859b          	addiw	a1,a5,-4
 b52:	00000097          	auipc	ra,0x0
 b56:	934080e7          	jalr	-1740(ra) # 486 <join_thread>
  threads_done++;
 b5a:	00001717          	auipc	a4,0x1
 b5e:	a1a70713          	addi	a4,a4,-1510 # 1574 <threads_done>
 b62:	431c                	lw	a5,0(a4)
 b64:	2785                	addiw	a5,a5,1
 b66:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 b68:	00001717          	auipc	a4,0x1
 b6c:	a0872703          	lw	a4,-1528(a4) # 1570 <num_threads>
 b70:	00f70863          	beq	a4,a5,b80 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 b74:	fec42503          	lw	a0,-20(s0)
 b78:	60e2                	ld	ra,24(sp)
 b7a:	6442                	ld	s0,16(sp)
 b7c:	6105                	addi	sp,sp,32
 b7e:	8082                	ret
    free_stacks();
 b80:	00000097          	auipc	ra,0x0
 b84:	dd4080e7          	jalr	-556(ra) # 954 <free_stacks>
 b88:	b7f5                	j	b74 <ithread_join+0x32>
