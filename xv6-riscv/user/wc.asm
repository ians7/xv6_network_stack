
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	20000d93          	li	s11,512
  32:	00001d17          	auipc	s10,0x1
  36:	55ed0d13          	addi	s10,s10,1374 # 1590 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  3a:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  3c:	00001a17          	auipc	s4,0x1
  40:	be4a0a13          	addi	s4,s4,-1052 # c20 <ithread_join+0x56>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  44:	a805                	j	74 <wc+0x74>
      if(strchr(" \r\t\n\v", buf[i]))
  46:	8552                	mv	a0,s4
  48:	00000097          	auipc	ra,0x0
  4c:	204080e7          	jalr	516(ra) # 24c <strchr>
  50:	c919                	beqz	a0,66 <wc+0x66>
        inword = 0;
  52:	4901                	li	s2,0
    for(i=0; i<n; i++){
  54:	0485                	addi	s1,s1,1
  56:	01348d63          	beq	s1,s3,70 <wc+0x70>
      if(buf[i] == '\n')
  5a:	0004c583          	lbu	a1,0(s1)
  5e:	ff5594e3          	bne	a1,s5,46 <wc+0x46>
        l++;
  62:	2b85                	addiw	s7,s7,1
  64:	b7cd                	j	46 <wc+0x46>
      else if(!inword){
  66:	fe0917e3          	bnez	s2,54 <wc+0x54>
        w++;
  6a:	2c05                	addiw	s8,s8,1
        inword = 1;
  6c:	4905                	li	s2,1
  6e:	b7dd                	j	54 <wc+0x54>
  70:	019b0cbb          	addw	s9,s6,s9
  while((n = read(fd, buf, sizeof(buf))) > 0){
  74:	866e                	mv	a2,s11
  76:	85ea                	mv	a1,s10
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	3d4080e7          	jalr	980(ra) # 450 <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
  8a:	00001497          	auipc	s1,0x1
  8e:	50648493          	addi	s1,s1,1286 # 1590 <buf>
  92:	009b09b3          	add	s3,s6,s1
  96:	b7d1                	j	5a <wc+0x5a>
      }
    }
  }
  if(n < 0){
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86e6                	mv	a3,s9
  a2:	8662                	mv	a2,s8
  a4:	85de                	mv	a1,s7
  a6:	00001517          	auipc	a0,0x1
  aa:	b9250513          	addi	a0,a0,-1134 # c38 <ithread_join+0x6e>
  ae:	00000097          	auipc	ra,0x0
  b2:	75e080e7          	jalr	1886(ra) # 80c <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	addi	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	b5450513          	addi	a0,a0,-1196 # c28 <ithread_join+0x5e>
  dc:	00000097          	auipc	ra,0x0
  e0:	730080e7          	jalr	1840(ra) # 80c <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	352080e7          	jalr	850(ra) # 438 <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	7179                	addi	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  f6:	4785                	li	a5,1
  f8:	04a7dc63          	bge	a5,a0,150 <main+0x62>
  fc:	ec26                	sd	s1,24(sp)
  fe:	e84a                	sd	s2,16(sp)
 100:	e44e                	sd	s3,8(sp)
 102:	00858913          	addi	s2,a1,8
 106:	ffe5099b          	addiw	s3,a0,-2
 10a:	02099793          	slli	a5,s3,0x20
 10e:	01d7d993          	srli	s3,a5,0x1d
 112:	05c1                	addi	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	35c080e7          	jalr	860(ra) # 478 <open>
 124:	84aa                	mv	s1,a0
 126:	04054663          	bltz	a0,172 <main+0x84>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	328080e7          	jalr	808(ra) # 460 <close>
  for(i = 1; i < argc; i++){
 140:	0921                	addi	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	2f0080e7          	jalr	752(ra) # 438 <exit>
 150:	ec26                	sd	s1,24(sp)
 152:	e84a                	sd	s2,16(sp)
 154:	e44e                	sd	s3,8(sp)
    wc(0, "");
 156:	00001597          	auipc	a1,0x1
 15a:	b3a58593          	addi	a1,a1,-1222 # c90 <ithread_join+0xc6>
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	ea0080e7          	jalr	-352(ra) # 0 <wc>
    exit(0);
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	2ce080e7          	jalr	718(ra) # 438 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 172:	00093583          	ld	a1,0(s2)
 176:	00001517          	auipc	a0,0x1
 17a:	ad250513          	addi	a0,a0,-1326 # c48 <ithread_join+0x7e>
 17e:	00000097          	auipc	ra,0x0
 182:	68e080e7          	jalr	1678(ra) # 80c <printf>
      exit(1);
 186:	4505                	li	a0,1
 188:	00000097          	auipc	ra,0x0
 18c:	2b0080e7          	jalr	688(ra) # 438 <exit>

0000000000000190 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 190:	1141                	addi	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	addi	s0,sp,16
  extern int main();
  main();
 198:	00000097          	auipc	ra,0x0
 19c:	f56080e7          	jalr	-170(ra) # ee <main>
  exit(0);
 1a0:	4501                	li	a0,0
 1a2:	00000097          	auipc	ra,0x0
 1a6:	296080e7          	jalr	662(ra) # 438 <exit>

00000000000001aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b2:	87aa                	mv	a5,a0
 1b4:	0585                	addi	a1,a1,1
 1b6:	0785                	addi	a5,a5,1
 1b8:	fff5c703          	lbu	a4,-1(a1)
 1bc:	fee78fa3          	sb	a4,-1(a5)
 1c0:	fb75                	bnez	a4,1b4 <strcpy+0xa>
    ;
  return os;
}
 1c2:	60a2                	ld	ra,8(sp)
 1c4:	6402                	ld	s0,0(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret

00000000000001ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e406                	sd	ra,8(sp)
 1ce:	e022                	sd	s0,0(sp)
 1d0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cb91                	beqz	a5,1ea <strcmp+0x20>
 1d8:	0005c703          	lbu	a4,0(a1)
 1dc:	00f71763          	bne	a4,a5,1ea <strcmp+0x20>
    p++, q++;
 1e0:	0505                	addi	a0,a0,1
 1e2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	fbe5                	bnez	a5,1d8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1ea:	0005c503          	lbu	a0,0(a1)
}
 1ee:	40a7853b          	subw	a0,a5,a0
 1f2:	60a2                	ld	ra,8(sp)
 1f4:	6402                	ld	s0,0(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret

00000000000001fa <strlen>:

uint
strlen(const char *s)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e406                	sd	ra,8(sp)
 1fe:	e022                	sd	s0,0(sp)
 200:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 202:	00054783          	lbu	a5,0(a0)
 206:	cf91                	beqz	a5,222 <strlen+0x28>
 208:	00150793          	addi	a5,a0,1
 20c:	86be                	mv	a3,a5
 20e:	0785                	addi	a5,a5,1
 210:	fff7c703          	lbu	a4,-1(a5)
 214:	ff65                	bnez	a4,20c <strlen+0x12>
 216:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 21a:	60a2                	ld	ra,8(sp)
 21c:	6402                	ld	s0,0(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  for(n = 0; s[n]; n++)
 222:	4501                	li	a0,0
 224:	bfdd                	j	21a <strlen+0x20>

0000000000000226 <memset>:

void*
memset(void *dst, int c, uint n)
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 22e:	ca19                	beqz	a2,244 <memset+0x1e>
 230:	87aa                	mv	a5,a0
 232:	1602                	slli	a2,a2,0x20
 234:	9201                	srli	a2,a2,0x20
 236:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 23a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 23e:	0785                	addi	a5,a5,1
 240:	fee79de3          	bne	a5,a4,23a <memset+0x14>
  }
  return dst;
}
 244:	60a2                	ld	ra,8(sp)
 246:	6402                	ld	s0,0(sp)
 248:	0141                	addi	sp,sp,16
 24a:	8082                	ret

000000000000024c <strchr>:

char*
strchr(const char *s, char c)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	addi	s0,sp,16
  for(; *s; s++)
 254:	00054783          	lbu	a5,0(a0)
 258:	cf81                	beqz	a5,270 <strchr+0x24>
    if(*s == c)
 25a:	00f58763          	beq	a1,a5,268 <strchr+0x1c>
  for(; *s; s++)
 25e:	0505                	addi	a0,a0,1
 260:	00054783          	lbu	a5,0(a0)
 264:	fbfd                	bnez	a5,25a <strchr+0xe>
      return (char*)s;
  return 0;
 266:	4501                	li	a0,0
}
 268:	60a2                	ld	ra,8(sp)
 26a:	6402                	ld	s0,0(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret
  return 0;
 270:	4501                	li	a0,0
 272:	bfdd                	j	268 <strchr+0x1c>

0000000000000274 <gets>:

char*
gets(char *buf, int max)
{
 274:	711d                	addi	sp,sp,-96
 276:	ec86                	sd	ra,88(sp)
 278:	e8a2                	sd	s0,80(sp)
 27a:	e4a6                	sd	s1,72(sp)
 27c:	e0ca                	sd	s2,64(sp)
 27e:	fc4e                	sd	s3,56(sp)
 280:	f852                	sd	s4,48(sp)
 282:	f456                	sd	s5,40(sp)
 284:	f05a                	sd	s6,32(sp)
 286:	ec5e                	sd	s7,24(sp)
 288:	e862                	sd	s8,16(sp)
 28a:	1080                	addi	s0,sp,96
 28c:	8baa                	mv	s7,a0
 28e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 290:	892a                	mv	s2,a0
 292:	4481                	li	s1,0
    cc = read(0, &c, 1);
 294:	faf40b13          	addi	s6,s0,-81
 298:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 29a:	8c26                	mv	s8,s1
 29c:	0014899b          	addiw	s3,s1,1
 2a0:	84ce                	mv	s1,s3
 2a2:	0349d663          	bge	s3,s4,2ce <gets+0x5a>
    cc = read(0, &c, 1);
 2a6:	8656                	mv	a2,s5
 2a8:	85da                	mv	a1,s6
 2aa:	4501                	li	a0,0
 2ac:	00000097          	auipc	ra,0x0
 2b0:	1a4080e7          	jalr	420(ra) # 450 <read>
    if(cc < 1)
 2b4:	00a05d63          	blez	a0,2ce <gets+0x5a>
      break;
    buf[i++] = c;
 2b8:	faf44783          	lbu	a5,-81(s0)
 2bc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2c0:	0905                	addi	s2,s2,1
 2c2:	ff678713          	addi	a4,a5,-10
 2c6:	c319                	beqz	a4,2cc <gets+0x58>
 2c8:	17cd                	addi	a5,a5,-13
 2ca:	fbe1                	bnez	a5,29a <gets+0x26>
    buf[i++] = c;
 2cc:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 2ce:	9c5e                	add	s8,s8,s7
 2d0:	000c0023          	sb	zero,0(s8)
  return buf;
}
 2d4:	855e                	mv	a0,s7
 2d6:	60e6                	ld	ra,88(sp)
 2d8:	6446                	ld	s0,80(sp)
 2da:	64a6                	ld	s1,72(sp)
 2dc:	6906                	ld	s2,64(sp)
 2de:	79e2                	ld	s3,56(sp)
 2e0:	7a42                	ld	s4,48(sp)
 2e2:	7aa2                	ld	s5,40(sp)
 2e4:	7b02                	ld	s6,32(sp)
 2e6:	6be2                	ld	s7,24(sp)
 2e8:	6c42                	ld	s8,16(sp)
 2ea:	6125                	addi	sp,sp,96
 2ec:	8082                	ret

00000000000002ee <stat>:

int
stat(const char *n, struct stat *st)
{
 2ee:	1101                	addi	sp,sp,-32
 2f0:	ec06                	sd	ra,24(sp)
 2f2:	e822                	sd	s0,16(sp)
 2f4:	e04a                	sd	s2,0(sp)
 2f6:	1000                	addi	s0,sp,32
 2f8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2fa:	4581                	li	a1,0
 2fc:	00000097          	auipc	ra,0x0
 300:	17c080e7          	jalr	380(ra) # 478 <open>
  if(fd < 0)
 304:	02054663          	bltz	a0,330 <stat+0x42>
 308:	e426                	sd	s1,8(sp)
 30a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 30c:	85ca                	mv	a1,s2
 30e:	00000097          	auipc	ra,0x0
 312:	182080e7          	jalr	386(ra) # 490 <fstat>
 316:	892a                	mv	s2,a0
  close(fd);
 318:	8526                	mv	a0,s1
 31a:	00000097          	auipc	ra,0x0
 31e:	146080e7          	jalr	326(ra) # 460 <close>
  return r;
 322:	64a2                	ld	s1,8(sp)
}
 324:	854a                	mv	a0,s2
 326:	60e2                	ld	ra,24(sp)
 328:	6442                	ld	s0,16(sp)
 32a:	6902                	ld	s2,0(sp)
 32c:	6105                	addi	sp,sp,32
 32e:	8082                	ret
    return -1;
 330:	57fd                	li	a5,-1
 332:	893e                	mv	s2,a5
 334:	bfc5                	j	324 <stat+0x36>

0000000000000336 <atoi>:

int
atoi(const char *s)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 33e:	00054683          	lbu	a3,0(a0)
 342:	fd06879b          	addiw	a5,a3,-48
 346:	0ff7f793          	zext.b	a5,a5
 34a:	4625                	li	a2,9
 34c:	02f66963          	bltu	a2,a5,37e <atoi+0x48>
 350:	872a                	mv	a4,a0
  n = 0;
 352:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 354:	0705                	addi	a4,a4,1
 356:	0025179b          	slliw	a5,a0,0x2
 35a:	9fa9                	addw	a5,a5,a0
 35c:	0017979b          	slliw	a5,a5,0x1
 360:	9fb5                	addw	a5,a5,a3
 362:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 366:	00074683          	lbu	a3,0(a4)
 36a:	fd06879b          	addiw	a5,a3,-48
 36e:	0ff7f793          	zext.b	a5,a5
 372:	fef671e3          	bgeu	a2,a5,354 <atoi+0x1e>
  return n;
}
 376:	60a2                	ld	ra,8(sp)
 378:	6402                	ld	s0,0(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret
  n = 0;
 37e:	4501                	li	a0,0
 380:	bfdd                	j	376 <atoi+0x40>

0000000000000382 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 382:	1141                	addi	sp,sp,-16
 384:	e406                	sd	ra,8(sp)
 386:	e022                	sd	s0,0(sp)
 388:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 38a:	02b57563          	bgeu	a0,a1,3b4 <memmove+0x32>
    while(n-- > 0)
 38e:	00c05f63          	blez	a2,3ac <memmove+0x2a>
 392:	1602                	slli	a2,a2,0x20
 394:	9201                	srli	a2,a2,0x20
 396:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 39a:	872a                	mv	a4,a0
      *dst++ = *src++;
 39c:	0585                	addi	a1,a1,1
 39e:	0705                	addi	a4,a4,1
 3a0:	fff5c683          	lbu	a3,-1(a1)
 3a4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3a8:	fee79ae3          	bne	a5,a4,39c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3ac:	60a2                	ld	ra,8(sp)
 3ae:	6402                	ld	s0,0(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
    while(n-- > 0)
 3b4:	fec05ce3          	blez	a2,3ac <memmove+0x2a>
    dst += n;
 3b8:	00c50733          	add	a4,a0,a2
    src += n;
 3bc:	95b2                	add	a1,a1,a2
 3be:	fff6079b          	addiw	a5,a2,-1
 3c2:	1782                	slli	a5,a5,0x20
 3c4:	9381                	srli	a5,a5,0x20
 3c6:	fff7c793          	not	a5,a5
 3ca:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3cc:	15fd                	addi	a1,a1,-1
 3ce:	177d                	addi	a4,a4,-1
 3d0:	0005c683          	lbu	a3,0(a1)
 3d4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3d8:	fef71ae3          	bne	a4,a5,3cc <memmove+0x4a>
 3dc:	bfc1                	j	3ac <memmove+0x2a>

00000000000003de <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e406                	sd	ra,8(sp)
 3e2:	e022                	sd	s0,0(sp)
 3e4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3e6:	c61d                	beqz	a2,414 <memcmp+0x36>
 3e8:	1602                	slli	a2,a2,0x20
 3ea:	9201                	srli	a2,a2,0x20
 3ec:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 3f0:	00054783          	lbu	a5,0(a0)
 3f4:	0005c703          	lbu	a4,0(a1)
 3f8:	00e79863          	bne	a5,a4,408 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 3fc:	0505                	addi	a0,a0,1
    p2++;
 3fe:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 400:	fed518e3          	bne	a0,a3,3f0 <memcmp+0x12>
  }
  return 0;
 404:	4501                	li	a0,0
 406:	a019                	j	40c <memcmp+0x2e>
      return *p1 - *p2;
 408:	40e7853b          	subw	a0,a5,a4
}
 40c:	60a2                	ld	ra,8(sp)
 40e:	6402                	ld	s0,0(sp)
 410:	0141                	addi	sp,sp,16
 412:	8082                	ret
  return 0;
 414:	4501                	li	a0,0
 416:	bfdd                	j	40c <memcmp+0x2e>

0000000000000418 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 418:	1141                	addi	sp,sp,-16
 41a:	e406                	sd	ra,8(sp)
 41c:	e022                	sd	s0,0(sp)
 41e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 420:	00000097          	auipc	ra,0x0
 424:	f62080e7          	jalr	-158(ra) # 382 <memmove>
}
 428:	60a2                	ld	ra,8(sp)
 42a:	6402                	ld	s0,0(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret

0000000000000430 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 430:	4885                	li	a7,1
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <exit>:
.global exit
exit:
 li a7, SYS_exit
 438:	4889                	li	a7,2
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <wait>:
.global wait
wait:
 li a7, SYS_wait
 440:	488d                	li	a7,3
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 448:	4891                	li	a7,4
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <read>:
.global read
read:
 li a7, SYS_read
 450:	4895                	li	a7,5
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <write>:
.global write
write:
 li a7, SYS_write
 458:	48c1                	li	a7,16
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <close>:
.global close
close:
 li a7, SYS_close
 460:	48d5                	li	a7,21
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <kill>:
.global kill
kill:
 li a7, SYS_kill
 468:	4899                	li	a7,6
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <exec>:
.global exec
exec:
 li a7, SYS_exec
 470:	489d                	li	a7,7
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <open>:
.global open
open:
 li a7, SYS_open
 478:	48bd                	li	a7,15
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 480:	48c5                	li	a7,17
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 488:	48c9                	li	a7,18
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 490:	48a1                	li	a7,8
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <link>:
.global link
link:
 li a7, SYS_link
 498:	48cd                	li	a7,19
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4a0:	48d1                	li	a7,20
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4a8:	48a5                	li	a7,9
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4b0:	48a9                	li	a7,10
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4b8:	48ad                	li	a7,11
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4c0:	48b1                	li	a7,12
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4c8:	48b5                	li	a7,13
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4d0:	48b9                	li	a7,14
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 4d8:	48d9                	li	a7,22
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 4e0:	48dd                	li	a7,23
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 4e8:	48e1                	li	a7,24
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 4f0:	48e5                	li	a7,25
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <socket>:
.global socket
socket:
 li a7, SYS_socket
 4f8:	48e9                	li	a7,26
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <bind>:
.global bind
bind:
 li a7, SYS_bind
 500:	48ed                	li	a7,27
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <accept>:
.global accept
accept:
 li a7, SYS_accept
 508:	48f5                	li	a7,29
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <listen>:
.global listen
listen:
 li a7, SYS_listen
 510:	48f1                	li	a7,28
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <connect>:
.global connect
connect:
 li a7, SYS_connect
 518:	48f9                	li	a7,30
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <send>:
.global send
send:
 li a7, SYS_send
 520:	48fd                	li	a7,31
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <recv>:
.global recv
recv:
 li a7, SYS_recv
 528:	02000893          	li	a7,32
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <sendto>:
.global sendto
sendto:
 li a7, SYS_sendto
 532:	02100893          	li	a7,33
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <recvfrom>:
.global recvfrom
recvfrom:
 li a7, SYS_recvfrom
 53c:	02200893          	li	a7,34
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 546:	1101                	addi	sp,sp,-32
 548:	ec06                	sd	ra,24(sp)
 54a:	e822                	sd	s0,16(sp)
 54c:	1000                	addi	s0,sp,32
 54e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 552:	4605                	li	a2,1
 554:	fef40593          	addi	a1,s0,-17
 558:	00000097          	auipc	ra,0x0
 55c:	f00080e7          	jalr	-256(ra) # 458 <write>
}
 560:	60e2                	ld	ra,24(sp)
 562:	6442                	ld	s0,16(sp)
 564:	6105                	addi	sp,sp,32
 566:	8082                	ret

0000000000000568 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 568:	7139                	addi	sp,sp,-64
 56a:	fc06                	sd	ra,56(sp)
 56c:	f822                	sd	s0,48(sp)
 56e:	f04a                	sd	s2,32(sp)
 570:	ec4e                	sd	s3,24(sp)
 572:	0080                	addi	s0,sp,64
 574:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 576:	cad9                	beqz	a3,60c <printint+0xa4>
 578:	01f5d79b          	srliw	a5,a1,0x1f
 57c:	cbc1                	beqz	a5,60c <printint+0xa4>
    neg = 1;
    x = -xx;
 57e:	40b005bb          	negw	a1,a1
    neg = 1;
 582:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 584:	fc040993          	addi	s3,s0,-64
  neg = 0;
 588:	86ce                	mv	a3,s3
  i = 0;
 58a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 58c:	00000817          	auipc	a6,0x0
 590:	76480813          	addi	a6,a6,1892 # cf0 <digits>
 594:	88ba                	mv	a7,a4
 596:	0017051b          	addiw	a0,a4,1
 59a:	872a                	mv	a4,a0
 59c:	02c5f7bb          	remuw	a5,a1,a2
 5a0:	1782                	slli	a5,a5,0x20
 5a2:	9381                	srli	a5,a5,0x20
 5a4:	97c2                	add	a5,a5,a6
 5a6:	0007c783          	lbu	a5,0(a5)
 5aa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5ae:	87ae                	mv	a5,a1
 5b0:	02c5d5bb          	divuw	a1,a1,a2
 5b4:	0685                	addi	a3,a3,1
 5b6:	fcc7ffe3          	bgeu	a5,a2,594 <printint+0x2c>
  if(neg)
 5ba:	00030c63          	beqz	t1,5d2 <printint+0x6a>
    buf[i++] = '-';
 5be:	fd050793          	addi	a5,a0,-48
 5c2:	00878533          	add	a0,a5,s0
 5c6:	02d00793          	li	a5,45
 5ca:	fef50823          	sb	a5,-16(a0)
 5ce:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 5d2:	02e05763          	blez	a4,600 <printint+0x98>
 5d6:	f426                	sd	s1,40(sp)
 5d8:	377d                	addiw	a4,a4,-1
 5da:	00e984b3          	add	s1,s3,a4
 5de:	19fd                	addi	s3,s3,-1
 5e0:	99ba                	add	s3,s3,a4
 5e2:	1702                	slli	a4,a4,0x20
 5e4:	9301                	srli	a4,a4,0x20
 5e6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5ea:	0004c583          	lbu	a1,0(s1)
 5ee:	854a                	mv	a0,s2
 5f0:	00000097          	auipc	ra,0x0
 5f4:	f56080e7          	jalr	-170(ra) # 546 <putc>
  while(--i >= 0)
 5f8:	14fd                	addi	s1,s1,-1
 5fa:	ff3498e3          	bne	s1,s3,5ea <printint+0x82>
 5fe:	74a2                	ld	s1,40(sp)
}
 600:	70e2                	ld	ra,56(sp)
 602:	7442                	ld	s0,48(sp)
 604:	7902                	ld	s2,32(sp)
 606:	69e2                	ld	s3,24(sp)
 608:	6121                	addi	sp,sp,64
 60a:	8082                	ret
  neg = 0;
 60c:	4301                	li	t1,0
 60e:	bf9d                	j	584 <printint+0x1c>

0000000000000610 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 610:	715d                	addi	sp,sp,-80
 612:	e486                	sd	ra,72(sp)
 614:	e0a2                	sd	s0,64(sp)
 616:	f84a                	sd	s2,48(sp)
 618:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 61a:	0005c903          	lbu	s2,0(a1)
 61e:	1a090b63          	beqz	s2,7d4 <vprintf+0x1c4>
 622:	fc26                	sd	s1,56(sp)
 624:	f44e                	sd	s3,40(sp)
 626:	f052                	sd	s4,32(sp)
 628:	ec56                	sd	s5,24(sp)
 62a:	e85a                	sd	s6,16(sp)
 62c:	e45e                	sd	s7,8(sp)
 62e:	8aaa                	mv	s5,a0
 630:	8bb2                	mv	s7,a2
 632:	00158493          	addi	s1,a1,1
  state = 0;
 636:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 638:	02500a13          	li	s4,37
 63c:	4b55                	li	s6,21
 63e:	a839                	j	65c <vprintf+0x4c>
        putc(fd, c);
 640:	85ca                	mv	a1,s2
 642:	8556                	mv	a0,s5
 644:	00000097          	auipc	ra,0x0
 648:	f02080e7          	jalr	-254(ra) # 546 <putc>
 64c:	a019                	j	652 <vprintf+0x42>
    } else if(state == '%'){
 64e:	01498d63          	beq	s3,s4,668 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 652:	0485                	addi	s1,s1,1
 654:	fff4c903          	lbu	s2,-1(s1)
 658:	16090863          	beqz	s2,7c8 <vprintf+0x1b8>
    if(state == 0){
 65c:	fe0999e3          	bnez	s3,64e <vprintf+0x3e>
      if(c == '%'){
 660:	ff4910e3          	bne	s2,s4,640 <vprintf+0x30>
        state = '%';
 664:	89d2                	mv	s3,s4
 666:	b7f5                	j	652 <vprintf+0x42>
      if(c == 'd'){
 668:	13490563          	beq	s2,s4,792 <vprintf+0x182>
 66c:	f9d9079b          	addiw	a5,s2,-99
 670:	0ff7f793          	zext.b	a5,a5
 674:	12fb6863          	bltu	s6,a5,7a4 <vprintf+0x194>
 678:	f9d9079b          	addiw	a5,s2,-99
 67c:	0ff7f713          	zext.b	a4,a5
 680:	12eb6263          	bltu	s6,a4,7a4 <vprintf+0x194>
 684:	00271793          	slli	a5,a4,0x2
 688:	00000717          	auipc	a4,0x0
 68c:	61070713          	addi	a4,a4,1552 # c98 <ithread_join+0xce>
 690:	97ba                	add	a5,a5,a4
 692:	439c                	lw	a5,0(a5)
 694:	97ba                	add	a5,a5,a4
 696:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 698:	008b8913          	addi	s2,s7,8
 69c:	4685                	li	a3,1
 69e:	4629                	li	a2,10
 6a0:	000ba583          	lw	a1,0(s7)
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	ec2080e7          	jalr	-318(ra) # 568 <printint>
 6ae:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b745                	j	652 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	008b8913          	addi	s2,s7,8
 6b8:	4681                	li	a3,0
 6ba:	4629                	li	a2,10
 6bc:	000ba583          	lw	a1,0(s7)
 6c0:	8556                	mv	a0,s5
 6c2:	00000097          	auipc	ra,0x0
 6c6:	ea6080e7          	jalr	-346(ra) # 568 <printint>
 6ca:	8bca                	mv	s7,s2
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b751                	j	652 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6d0:	008b8913          	addi	s2,s7,8
 6d4:	4681                	li	a3,0
 6d6:	4641                	li	a2,16
 6d8:	000ba583          	lw	a1,0(s7)
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	e8a080e7          	jalr	-374(ra) # 568 <printint>
 6e6:	8bca                	mv	s7,s2
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	b7a5                	j	652 <vprintf+0x42>
 6ec:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6ee:	008b8793          	addi	a5,s7,8
 6f2:	8c3e                	mv	s8,a5
 6f4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6f8:	03000593          	li	a1,48
 6fc:	8556                	mv	a0,s5
 6fe:	00000097          	auipc	ra,0x0
 702:	e48080e7          	jalr	-440(ra) # 546 <putc>
  putc(fd, 'x');
 706:	07800593          	li	a1,120
 70a:	8556                	mv	a0,s5
 70c:	00000097          	auipc	ra,0x0
 710:	e3a080e7          	jalr	-454(ra) # 546 <putc>
 714:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 716:	00000b97          	auipc	s7,0x0
 71a:	5dab8b93          	addi	s7,s7,1498 # cf0 <digits>
 71e:	03c9d793          	srli	a5,s3,0x3c
 722:	97de                	add	a5,a5,s7
 724:	0007c583          	lbu	a1,0(a5)
 728:	8556                	mv	a0,s5
 72a:	00000097          	auipc	ra,0x0
 72e:	e1c080e7          	jalr	-484(ra) # 546 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 732:	0992                	slli	s3,s3,0x4
 734:	397d                	addiw	s2,s2,-1
 736:	fe0914e3          	bnez	s2,71e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 73a:	8be2                	mv	s7,s8
      state = 0;
 73c:	4981                	li	s3,0
 73e:	6c02                	ld	s8,0(sp)
 740:	bf09                	j	652 <vprintf+0x42>
        s = va_arg(ap, char*);
 742:	008b8993          	addi	s3,s7,8
 746:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 74a:	02090163          	beqz	s2,76c <vprintf+0x15c>
        while(*s != 0){
 74e:	00094583          	lbu	a1,0(s2)
 752:	c9a5                	beqz	a1,7c2 <vprintf+0x1b2>
          putc(fd, *s);
 754:	8556                	mv	a0,s5
 756:	00000097          	auipc	ra,0x0
 75a:	df0080e7          	jalr	-528(ra) # 546 <putc>
          s++;
 75e:	0905                	addi	s2,s2,1
        while(*s != 0){
 760:	00094583          	lbu	a1,0(s2)
 764:	f9e5                	bnez	a1,754 <vprintf+0x144>
        s = va_arg(ap, char*);
 766:	8bce                	mv	s7,s3
      state = 0;
 768:	4981                	li	s3,0
 76a:	b5e5                	j	652 <vprintf+0x42>
          s = "(null)";
 76c:	00000917          	auipc	s2,0x0
 770:	4f490913          	addi	s2,s2,1268 # c60 <ithread_join+0x96>
        while(*s != 0){
 774:	02800593          	li	a1,40
 778:	bff1                	j	754 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 77a:	008b8913          	addi	s2,s7,8
 77e:	000bc583          	lbu	a1,0(s7)
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	dc2080e7          	jalr	-574(ra) # 546 <putc>
 78c:	8bca                	mv	s7,s2
      state = 0;
 78e:	4981                	li	s3,0
 790:	b5c9                	j	652 <vprintf+0x42>
        putc(fd, c);
 792:	02500593          	li	a1,37
 796:	8556                	mv	a0,s5
 798:	00000097          	auipc	ra,0x0
 79c:	dae080e7          	jalr	-594(ra) # 546 <putc>
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	bd45                	j	652 <vprintf+0x42>
        putc(fd, '%');
 7a4:	02500593          	li	a1,37
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	d9c080e7          	jalr	-612(ra) # 546 <putc>
        putc(fd, c);
 7b2:	85ca                	mv	a1,s2
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	d90080e7          	jalr	-624(ra) # 546 <putc>
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	bd49                	j	652 <vprintf+0x42>
        s = va_arg(ap, char*);
 7c2:	8bce                	mv	s7,s3
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	b571                	j	652 <vprintf+0x42>
 7c8:	74e2                	ld	s1,56(sp)
 7ca:	79a2                	ld	s3,40(sp)
 7cc:	7a02                	ld	s4,32(sp)
 7ce:	6ae2                	ld	s5,24(sp)
 7d0:	6b42                	ld	s6,16(sp)
 7d2:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7d4:	60a6                	ld	ra,72(sp)
 7d6:	6406                	ld	s0,64(sp)
 7d8:	7942                	ld	s2,48(sp)
 7da:	6161                	addi	sp,sp,80
 7dc:	8082                	ret

00000000000007de <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7de:	715d                	addi	sp,sp,-80
 7e0:	ec06                	sd	ra,24(sp)
 7e2:	e822                	sd	s0,16(sp)
 7e4:	1000                	addi	s0,sp,32
 7e6:	e010                	sd	a2,0(s0)
 7e8:	e414                	sd	a3,8(s0)
 7ea:	e818                	sd	a4,16(s0)
 7ec:	ec1c                	sd	a5,24(s0)
 7ee:	03043023          	sd	a6,32(s0)
 7f2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f6:	8622                	mv	a2,s0
 7f8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7fc:	00000097          	auipc	ra,0x0
 800:	e14080e7          	jalr	-492(ra) # 610 <vprintf>
}
 804:	60e2                	ld	ra,24(sp)
 806:	6442                	ld	s0,16(sp)
 808:	6161                	addi	sp,sp,80
 80a:	8082                	ret

000000000000080c <printf>:

void
printf(const char *fmt, ...)
{
 80c:	711d                	addi	sp,sp,-96
 80e:	ec06                	sd	ra,24(sp)
 810:	e822                	sd	s0,16(sp)
 812:	1000                	addi	s0,sp,32
 814:	e40c                	sd	a1,8(s0)
 816:	e810                	sd	a2,16(s0)
 818:	ec14                	sd	a3,24(s0)
 81a:	f018                	sd	a4,32(s0)
 81c:	f41c                	sd	a5,40(s0)
 81e:	03043823          	sd	a6,48(s0)
 822:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 826:	00840613          	addi	a2,s0,8
 82a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 82e:	85aa                	mv	a1,a0
 830:	4505                	li	a0,1
 832:	00000097          	auipc	ra,0x0
 836:	dde080e7          	jalr	-546(ra) # 610 <vprintf>
}
 83a:	60e2                	ld	ra,24(sp)
 83c:	6442                	ld	s0,16(sp)
 83e:	6125                	addi	sp,sp,96
 840:	8082                	ret

0000000000000842 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 842:	1141                	addi	sp,sp,-16
 844:	e406                	sd	ra,8(sp)
 846:	e022                	sd	s0,0(sp)
 848:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 84a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84e:	00001797          	auipc	a5,0x1
 852:	d227b783          	ld	a5,-734(a5) # 1570 <freep>
 856:	a039                	j	864 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 858:	6398                	ld	a4,0(a5)
 85a:	00e7e463          	bltu	a5,a4,862 <free+0x20>
 85e:	00e6ea63          	bltu	a3,a4,872 <free+0x30>
{
 862:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 864:	fed7fae3          	bgeu	a5,a3,858 <free+0x16>
 868:	6398                	ld	a4,0(a5)
 86a:	00e6e463          	bltu	a3,a4,872 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86e:	fee7eae3          	bltu	a5,a4,862 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 872:	ff852583          	lw	a1,-8(a0)
 876:	6390                	ld	a2,0(a5)
 878:	02059813          	slli	a6,a1,0x20
 87c:	01c85713          	srli	a4,a6,0x1c
 880:	9736                	add	a4,a4,a3
 882:	02e60563          	beq	a2,a4,8ac <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 886:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 88a:	4790                	lw	a2,8(a5)
 88c:	02061593          	slli	a1,a2,0x20
 890:	01c5d713          	srli	a4,a1,0x1c
 894:	973e                	add	a4,a4,a5
 896:	02e68263          	beq	a3,a4,8ba <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 89a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 89c:	00001717          	auipc	a4,0x1
 8a0:	ccf73a23          	sd	a5,-812(a4) # 1570 <freep>
}
 8a4:	60a2                	ld	ra,8(sp)
 8a6:	6402                	ld	s0,0(sp)
 8a8:	0141                	addi	sp,sp,16
 8aa:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8ac:	4618                	lw	a4,8(a2)
 8ae:	9f2d                	addw	a4,a4,a1
 8b0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b4:	6398                	ld	a4,0(a5)
 8b6:	6310                	ld	a2,0(a4)
 8b8:	b7f9                	j	886 <free+0x44>
    p->s.size += bp->s.size;
 8ba:	ff852703          	lw	a4,-8(a0)
 8be:	9f31                	addw	a4,a4,a2
 8c0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8c2:	ff053683          	ld	a3,-16(a0)
 8c6:	bfd1                	j	89a <free+0x58>

00000000000008c8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c8:	7139                	addi	sp,sp,-64
 8ca:	fc06                	sd	ra,56(sp)
 8cc:	f822                	sd	s0,48(sp)
 8ce:	f04a                	sd	s2,32(sp)
 8d0:	ec4e                	sd	s3,24(sp)
 8d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d4:	02051993          	slli	s3,a0,0x20
 8d8:	0209d993          	srli	s3,s3,0x20
 8dc:	09bd                	addi	s3,s3,15
 8de:	0049d993          	srli	s3,s3,0x4
 8e2:	2985                	addiw	s3,s3,1
 8e4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8e6:	00001517          	auipc	a0,0x1
 8ea:	c8a53503          	ld	a0,-886(a0) # 1570 <freep>
 8ee:	c905                	beqz	a0,91e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f2:	4798                	lw	a4,8(a5)
 8f4:	09377a63          	bgeu	a4,s3,988 <malloc+0xc0>
 8f8:	f426                	sd	s1,40(sp)
 8fa:	e852                	sd	s4,16(sp)
 8fc:	e456                	sd	s5,8(sp)
 8fe:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 900:	8a4e                	mv	s4,s3
 902:	6705                	lui	a4,0x1
 904:	00e9f363          	bgeu	s3,a4,90a <malloc+0x42>
 908:	6a05                	lui	s4,0x1
 90a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 90e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 912:	00001497          	auipc	s1,0x1
 916:	c5e48493          	addi	s1,s1,-930 # 1570 <freep>
  if(p == (char*)-1)
 91a:	5afd                	li	s5,-1
 91c:	a089                	j	95e <malloc+0x96>
 91e:	f426                	sd	s1,40(sp)
 920:	e852                	sd	s4,16(sp)
 922:	e456                	sd	s5,8(sp)
 924:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 926:	00001797          	auipc	a5,0x1
 92a:	e6a78793          	addi	a5,a5,-406 # 1790 <base>
 92e:	00001717          	auipc	a4,0x1
 932:	c4f73123          	sd	a5,-958(a4) # 1570 <freep>
 936:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 938:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 93c:	b7d1                	j	900 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 93e:	6398                	ld	a4,0(a5)
 940:	e118                	sd	a4,0(a0)
 942:	a8b9                	j	9a0 <malloc+0xd8>
  hp->s.size = nu;
 944:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 948:	0541                	addi	a0,a0,16
 94a:	00000097          	auipc	ra,0x0
 94e:	ef8080e7          	jalr	-264(ra) # 842 <free>
  return freep;
 952:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 954:	c135                	beqz	a0,9b8 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 956:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 958:	4798                	lw	a4,8(a5)
 95a:	03277363          	bgeu	a4,s2,980 <malloc+0xb8>
    if(p == freep)
 95e:	6098                	ld	a4,0(s1)
 960:	853e                	mv	a0,a5
 962:	fef71ae3          	bne	a4,a5,956 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 966:	8552                	mv	a0,s4
 968:	00000097          	auipc	ra,0x0
 96c:	b58080e7          	jalr	-1192(ra) # 4c0 <sbrk>
  if(p == (char*)-1)
 970:	fd551ae3          	bne	a0,s5,944 <malloc+0x7c>
        return 0;
 974:	4501                	li	a0,0
 976:	74a2                	ld	s1,40(sp)
 978:	6a42                	ld	s4,16(sp)
 97a:	6aa2                	ld	s5,8(sp)
 97c:	6b02                	ld	s6,0(sp)
 97e:	a03d                	j	9ac <malloc+0xe4>
 980:	74a2                	ld	s1,40(sp)
 982:	6a42                	ld	s4,16(sp)
 984:	6aa2                	ld	s5,8(sp)
 986:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 988:	fae90be3          	beq	s2,a4,93e <malloc+0x76>
        p->s.size -= nunits;
 98c:	4137073b          	subw	a4,a4,s3
 990:	c798                	sw	a4,8(a5)
        p += p->s.size;
 992:	02071693          	slli	a3,a4,0x20
 996:	01c6d713          	srli	a4,a3,0x1c
 99a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 99c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a0:	00001717          	auipc	a4,0x1
 9a4:	bca73823          	sd	a0,-1072(a4) # 1570 <freep>
      return (void*)(p + 1);
 9a8:	01078513          	addi	a0,a5,16
  }
}
 9ac:	70e2                	ld	ra,56(sp)
 9ae:	7442                	ld	s0,48(sp)
 9b0:	7902                	ld	s2,32(sp)
 9b2:	69e2                	ld	s3,24(sp)
 9b4:	6121                	addi	sp,sp,64
 9b6:	8082                	ret
 9b8:	74a2                	ld	s1,40(sp)
 9ba:	6a42                	ld	s4,16(sp)
 9bc:	6aa2                	ld	s5,8(sp)
 9be:	6b02                	ld	s6,0(sp)
 9c0:	b7f5                	j	9ac <malloc+0xe4>

00000000000009c2 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 9c2:	1141                	addi	sp,sp,-16
 9c4:	e406                	sd	ra,8(sp)
 9c6:	e022                	sd	s0,0(sp)
 9c8:	0800                	addi	s0,sp,16
  thread_exit(status);
 9ca:	2501                	sext.w	a0,a0
 9cc:	00000097          	auipc	ra,0x0
 9d0:	b24080e7          	jalr	-1244(ra) # 4f0 <thread_exit>
}
 9d4:	60a2                	ld	ra,8(sp)
 9d6:	6402                	ld	s0,0(sp)
 9d8:	0141                	addi	sp,sp,16
 9da:	8082                	ret

00000000000009dc <free_stacks>:
int free_stacks() {
 9dc:	7179                	addi	sp,sp,-48
 9de:	f406                	sd	ra,40(sp)
 9e0:	f022                	sd	s0,32(sp)
 9e2:	ec26                	sd	s1,24(sp)
 9e4:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 9e6:	00001797          	auipc	a5,0x1
 9ea:	b9a7a783          	lw	a5,-1126(a5) # 1580 <num_threads>
 9ee:	04f05063          	blez	a5,a2e <free_stacks+0x52>
 9f2:	e84a                	sd	s2,16(sp)
 9f4:	e44e                	sd	s3,8(sp)
 9f6:	4481                	li	s1,0
    free(stacks[i]);
 9f8:	00001997          	auipc	s3,0x1
 9fc:	b8098993          	addi	s3,s3,-1152 # 1578 <stacks>
  for (int i = 0; i < num_threads; i++) {
 a00:	00001917          	auipc	s2,0x1
 a04:	b8090913          	addi	s2,s2,-1152 # 1580 <num_threads>
    free(stacks[i]);
 a08:	0009b783          	ld	a5,0(s3)
 a0c:	00349713          	slli	a4,s1,0x3
 a10:	97ba                	add	a5,a5,a4
 a12:	6388                	ld	a0,0(a5)
 a14:	00000097          	auipc	ra,0x0
 a18:	e2e080e7          	jalr	-466(ra) # 842 <free>
  for (int i = 0; i < num_threads; i++) {
 a1c:	0485                	addi	s1,s1,1
 a1e:	00092703          	lw	a4,0(s2)
 a22:	0004879b          	sext.w	a5,s1
 a26:	fee7c1e3          	blt	a5,a4,a08 <free_stacks+0x2c>
 a2a:	6942                	ld	s2,16(sp)
 a2c:	69a2                	ld	s3,8(sp)
  free(stacks);
 a2e:	00001497          	auipc	s1,0x1
 a32:	b4a48493          	addi	s1,s1,-1206 # 1578 <stacks>
 a36:	6088                	ld	a0,0(s1)
 a38:	00000097          	auipc	ra,0x0
 a3c:	e0a080e7          	jalr	-502(ra) # 842 <free>
  stacks = 0;
 a40:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 a44:	00001797          	auipc	a5,0x1
 a48:	b207ae23          	sw	zero,-1220(a5) # 1580 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 a4c:	47a1                	li	a5,8
 a4e:	00001717          	auipc	a4,0x1
 a52:	b0f72923          	sw	a5,-1262(a4) # 1560 <max_stacks>
  threads_done = 0;
 a56:	00001797          	auipc	a5,0x1
 a5a:	b207a723          	sw	zero,-1234(a5) # 1584 <threads_done>
}
 a5e:	4501                	li	a0,0
 a60:	70a2                	ld	ra,40(sp)
 a62:	7402                	ld	s0,32(sp)
 a64:	64e2                	ld	s1,24(sp)
 a66:	6145                	addi	sp,sp,48
 a68:	8082                	ret

0000000000000a6a <expand_num_threads>:
int expand_num_threads() {
 a6a:	1101                	addi	sp,sp,-32
 a6c:	ec06                	sd	ra,24(sp)
 a6e:	e822                	sd	s0,16(sp)
 a70:	e426                	sd	s1,8(sp)
 a72:	e04a                	sd	s2,0(sp)
 a74:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 a76:	00001797          	auipc	a5,0x1
 a7a:	aea78793          	addi	a5,a5,-1302 # 1560 <max_stacks>
 a7e:	4388                	lw	a0,0(a5)
 a80:	0015151b          	slliw	a0,a0,0x1
 a84:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 a86:	0035151b          	slliw	a0,a0,0x3
 a8a:	00000097          	auipc	ra,0x0
 a8e:	e3e080e7          	jalr	-450(ra) # 8c8 <malloc>
 a92:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 a94:	00001617          	auipc	a2,0x1
 a98:	aec62603          	lw	a2,-1300(a2) # 1580 <num_threads>
 a9c:	00001497          	auipc	s1,0x1
 aa0:	adc48493          	addi	s1,s1,-1316 # 1578 <stacks>
 aa4:	0036161b          	slliw	a2,a2,0x3
 aa8:	608c                	ld	a1,0(s1)
 aaa:	00000097          	auipc	ra,0x0
 aae:	8d8080e7          	jalr	-1832(ra) # 382 <memmove>
  free(stacks);
 ab2:	6088                	ld	a0,0(s1)
 ab4:	00000097          	auipc	ra,0x0
 ab8:	d8e080e7          	jalr	-626(ra) # 842 <free>
  stacks = new_stacks;
 abc:	0124b023          	sd	s2,0(s1)
}
 ac0:	4501                	li	a0,0
 ac2:	60e2                	ld	ra,24(sp)
 ac4:	6442                	ld	s0,16(sp)
 ac6:	64a2                	ld	s1,8(sp)
 ac8:	6902                	ld	s2,0(sp)
 aca:	6105                	addi	sp,sp,32
 acc:	8082                	ret

0000000000000ace <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 ace:	7179                	addi	sp,sp,-48
 ad0:	f406                	sd	ra,40(sp)
 ad2:	f022                	sd	s0,32(sp)
 ad4:	e84a                	sd	s2,16(sp)
 ad6:	e44e                	sd	s3,8(sp)
 ad8:	1800                	addi	s0,sp,48
 ada:	892a                	mv	s2,a0
 adc:	89ae                	mv	s3,a1
  if (stacks == 0) {
 ade:	00001797          	auipc	a5,0x1
 ae2:	a9a7b783          	ld	a5,-1382(a5) # 1578 <stacks>
 ae6:	c3d9                	beqz	a5,b6c <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 ae8:	00001797          	auipc	a5,0x1
 aec:	a787a783          	lw	a5,-1416(a5) # 1560 <max_stacks>
 af0:	00001717          	auipc	a4,0x1
 af4:	a9072703          	lw	a4,-1392(a4) # 1580 <num_threads>
 af8:	0af71463          	bne	a4,a5,ba0 <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 afc:	04000713          	li	a4,64
 b00:	08e78563          	beq	a5,a4,b8a <ithread_create+0xbc>
 b04:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 b06:	00000097          	auipc	ra,0x0
 b0a:	f64080e7          	jalr	-156(ra) # a6a <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 b0e:	6505                	lui	a0,0x1
 b10:	00000097          	auipc	ra,0x0
 b14:	db8080e7          	jalr	-584(ra) # 8c8 <malloc>
 b18:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 b1a:	00001717          	auipc	a4,0x1
 b1e:	a6672703          	lw	a4,-1434(a4) # 1580 <num_threads>
 b22:	070e                	slli	a4,a4,0x3
 b24:	00001797          	auipc	a5,0x1
 b28:	a547b783          	ld	a5,-1452(a5) # 1578 <stacks>
 b2c:	97ba                	add	a5,a5,a4
 b2e:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 b30:	00000697          	auipc	a3,0x0
 b34:	e9268693          	addi	a3,a3,-366 # 9c2 <ithread_exit>
 b38:	862a                	mv	a2,a0
 b3a:	85ce                	mv	a1,s3
 b3c:	854a                	mv	a0,s2
 b3e:	00000097          	auipc	ra,0x0
 b42:	9a2080e7          	jalr	-1630(ra) # 4e0 <create_thread>
 b46:	892a                	mv	s2,a0
  if (res != -1) {
 b48:	57fd                	li	a5,-1
 b4a:	04f50d63          	beq	a0,a5,ba4 <ithread_create+0xd6>
    num_threads++;
 b4e:	00001717          	auipc	a4,0x1
 b52:	a3270713          	addi	a4,a4,-1486 # 1580 <num_threads>
 b56:	431c                	lw	a5,0(a4)
 b58:	2785                	addiw	a5,a5,1
 b5a:	c31c                	sw	a5,0(a4)
 b5c:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 b5e:	854a                	mv	a0,s2
 b60:	70a2                	ld	ra,40(sp)
 b62:	7402                	ld	s0,32(sp)
 b64:	6942                	ld	s2,16(sp)
 b66:	69a2                	ld	s3,8(sp)
 b68:	6145                	addi	sp,sp,48
 b6a:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 b6c:	00001517          	auipc	a0,0x1
 b70:	9f452503          	lw	a0,-1548(a0) # 1560 <max_stacks>
 b74:	0035151b          	slliw	a0,a0,0x3
 b78:	00000097          	auipc	ra,0x0
 b7c:	d50080e7          	jalr	-688(ra) # 8c8 <malloc>
 b80:	00001797          	auipc	a5,0x1
 b84:	9ea7bc23          	sd	a0,-1544(a5) # 1578 <stacks>
 b88:	b785                	j	ae8 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 b8a:	00000517          	auipc	a0,0x0
 b8e:	0de50513          	addi	a0,a0,222 # c68 <ithread_join+0x9e>
 b92:	00000097          	auipc	ra,0x0
 b96:	c7a080e7          	jalr	-902(ra) # 80c <printf>
      return -1;
 b9a:	57fd                	li	a5,-1
 b9c:	893e                	mv	s2,a5
 b9e:	b7c1                	j	b5e <ithread_create+0x90>
 ba0:	ec26                	sd	s1,24(sp)
 ba2:	b7b5                	j	b0e <ithread_create+0x40>
    free(stack_ptr);
 ba4:	8526                	mv	a0,s1
 ba6:	00000097          	auipc	ra,0x0
 baa:	c9c080e7          	jalr	-868(ra) # 842 <free>
    stacks[num_threads] = 0;
 bae:	00001717          	auipc	a4,0x1
 bb2:	9d272703          	lw	a4,-1582(a4) # 1580 <num_threads>
 bb6:	070e                	slli	a4,a4,0x3
 bb8:	00001797          	auipc	a5,0x1
 bbc:	9c07b783          	ld	a5,-1600(a5) # 1578 <stacks>
 bc0:	97ba                	add	a5,a5,a4
 bc2:	0007b023          	sd	zero,0(a5)
 bc6:	64e2                	ld	s1,24(sp)
 bc8:	bf59                	j	b5e <ithread_create+0x90>

0000000000000bca <ithread_join>:

int ithread_join(int thread_id) {
 bca:	1101                	addi	sp,sp,-32
 bcc:	ec06                	sd	ra,24(sp)
 bce:	e822                	sd	s0,16(sp)
 bd0:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 bd2:	ff040793          	addi	a5,s0,-16
 bd6:	ffc7859b          	addiw	a1,a5,-4
 bda:	00000097          	auipc	ra,0x0
 bde:	90e080e7          	jalr	-1778(ra) # 4e8 <join_thread>
  threads_done++;
 be2:	00001717          	auipc	a4,0x1
 be6:	9a270713          	addi	a4,a4,-1630 # 1584 <threads_done>
 bea:	431c                	lw	a5,0(a4)
 bec:	2785                	addiw	a5,a5,1
 bee:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 bf0:	00001717          	auipc	a4,0x1
 bf4:	99072703          	lw	a4,-1648(a4) # 1580 <num_threads>
 bf8:	00f70863          	beq	a4,a5,c08 <ithread_join+0x3e>
    free_stacks();
  }
  return status;
}
 bfc:	fec42503          	lw	a0,-20(s0)
 c00:	60e2                	ld	ra,24(sp)
 c02:	6442                	ld	s0,16(sp)
 c04:	6105                	addi	sp,sp,32
 c06:	8082                	ret
    free_stacks();
 c08:	00000097          	auipc	ra,0x0
 c0c:	dd4080e7          	jalr	-556(ra) # 9dc <free_stacks>
 c10:	b7f5                	j	bfc <ithread_join+0x32>
