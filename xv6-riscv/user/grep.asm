
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	fd250a13          	addi	s4,a0,-46
  1a:	001a3a13          	seqz	s4,s4
    if(matchhere(re, text))
  1e:	85a6                	mv	a1,s1
  20:	854e                	mv	a0,s3
  22:	00000097          	auipc	ra,0x0
  26:	02e080e7          	jalr	46(ra) # 50 <matchhere>
  2a:	e911                	bnez	a0,3e <matchstar+0x3e>
  }while(*text!='\0' && (*text++==c || c=='.'));
  2c:	0004c783          	lbu	a5,0(s1)
  30:	cb81                	beqz	a5,40 <matchstar+0x40>
  32:	0485                	addi	s1,s1,1
  34:	ff2785e3          	beq	a5,s2,1e <matchstar+0x1e>
  38:	fe0a13e3          	bnez	s4,1e <matchstar+0x1e>
  3c:	a011                	j	40 <matchstar+0x40>
      return 1;
  3e:	4505                	li	a0,1
  return 0;
}
  40:	70a2                	ld	ra,40(sp)
  42:	7402                	ld	s0,32(sp)
  44:	64e2                	ld	s1,24(sp)
  46:	6942                	ld	s2,16(sp)
  48:	69a2                	ld	s3,8(sp)
  4a:	6a02                	ld	s4,0(sp)
  4c:	6145                	addi	sp,sp,48
  4e:	8082                	ret

0000000000000050 <matchhere>:
  if(re[0] == '\0')
  50:	00054703          	lbu	a4,0(a0)
  54:	c33d                	beqz	a4,ba <matchhere+0x6a>
{
  56:	1141                	addi	sp,sp,-16
  58:	e406                	sd	ra,8(sp)
  5a:	e022                	sd	s0,0(sp)
  5c:	0800                	addi	s0,sp,16
  5e:	87aa                	mv	a5,a0
  if(re[1] == '*')
  60:	00154683          	lbu	a3,1(a0)
  64:	02a00613          	li	a2,42
  68:	02c68363          	beq	a3,a2,8e <matchhere+0x3e>
  if(re[0] == '$' && re[1] == '\0')
  6c:	e681                	bnez	a3,74 <matchhere+0x24>
  6e:	fdc70693          	addi	a3,a4,-36
  72:	c69d                	beqz	a3,a0 <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  74:	0005c683          	lbu	a3,0(a1)
  return 0;
  78:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  7a:	c691                	beqz	a3,86 <matchhere+0x36>
  7c:	02d70763          	beq	a4,a3,aa <matchhere+0x5a>
  80:	fd270713          	addi	a4,a4,-46
  84:	c31d                	beqz	a4,aa <matchhere+0x5a>
}
  86:	60a2                	ld	ra,8(sp)
  88:	6402                	ld	s0,0(sp)
  8a:	0141                	addi	sp,sp,16
  8c:	8082                	ret
    return matchstar(re[0], re+2, text);
  8e:	862e                	mv	a2,a1
  90:	00250593          	addi	a1,a0,2
  94:	853a                	mv	a0,a4
  96:	00000097          	auipc	ra,0x0
  9a:	f6a080e7          	jalr	-150(ra) # 0 <matchstar>
  9e:	b7e5                	j	86 <matchhere+0x36>
    return *text == '\0';
  a0:	0005c503          	lbu	a0,0(a1)
  a4:	00153513          	seqz	a0,a0
  a8:	bff9                	j	86 <matchhere+0x36>
    return matchhere(re+1, text+1);
  aa:	0585                	addi	a1,a1,1
  ac:	00178513          	addi	a0,a5,1
  b0:	00000097          	auipc	ra,0x0
  b4:	fa0080e7          	jalr	-96(ra) # 50 <matchhere>
  b8:	b7f9                	j	86 <matchhere+0x36>
    return 1;
  ba:	4505                	li	a0,1
}
  bc:	8082                	ret

00000000000000be <match>:
{
  be:	1101                	addi	sp,sp,-32
  c0:	ec06                	sd	ra,24(sp)
  c2:	e822                	sd	s0,16(sp)
  c4:	e426                	sd	s1,8(sp)
  c6:	e04a                	sd	s2,0(sp)
  c8:	1000                	addi	s0,sp,32
  ca:	892a                	mv	s2,a0
  cc:	84ae                	mv	s1,a1
  if(re[0] == '^')
  ce:	00054703          	lbu	a4,0(a0)
  d2:	05e00793          	li	a5,94
  d6:	00f70e63          	beq	a4,a5,f2 <match+0x34>
    if(matchhere(re, text))
  da:	85a6                	mv	a1,s1
  dc:	854a                	mv	a0,s2
  de:	00000097          	auipc	ra,0x0
  e2:	f72080e7          	jalr	-142(ra) # 50 <matchhere>
  e6:	ed01                	bnez	a0,fe <match+0x40>
  }while(*text++ != '\0');
  e8:	0485                	addi	s1,s1,1
  ea:	fff4c783          	lbu	a5,-1(s1)
  ee:	f7f5                	bnez	a5,da <match+0x1c>
  f0:	a801                	j	100 <match+0x42>
    return matchhere(re+1, text);
  f2:	0505                	addi	a0,a0,1
  f4:	00000097          	auipc	ra,0x0
  f8:	f5c080e7          	jalr	-164(ra) # 50 <matchhere>
  fc:	a011                	j	100 <match+0x42>
      return 1;
  fe:	4505                	li	a0,1
}
 100:	60e2                	ld	ra,24(sp)
 102:	6442                	ld	s0,16(sp)
 104:	64a2                	ld	s1,8(sp)
 106:	6902                	ld	s2,0(sp)
 108:	6105                	addi	sp,sp,32
 10a:	8082                	ret

000000000000010c <grep>:
{
 10c:	711d                	addi	sp,sp,-96
 10e:	ec86                	sd	ra,88(sp)
 110:	e8a2                	sd	s0,80(sp)
 112:	e4a6                	sd	s1,72(sp)
 114:	e0ca                	sd	s2,64(sp)
 116:	fc4e                	sd	s3,56(sp)
 118:	f852                	sd	s4,48(sp)
 11a:	f456                	sd	s5,40(sp)
 11c:	f05a                	sd	s6,32(sp)
 11e:	ec5e                	sd	s7,24(sp)
 120:	e862                	sd	s8,16(sp)
 122:	e466                	sd	s9,8(sp)
 124:	e06a                	sd	s10,0(sp)
 126:	1080                	addi	s0,sp,96
 128:	8aaa                	mv	s5,a0
 12a:	8cae                	mv	s9,a1
  m = 0;
 12c:	4b01                	li	s6,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 12e:	3ff00d13          	li	s10,1023
 132:	00001b97          	auipc	s7,0x1
 136:	4eeb8b93          	addi	s7,s7,1262 # 1620 <buf>
    while((q = strchr(p, '\n')) != 0){
 13a:	49a9                	li	s3,10
        write(1, p, q+1 - p);
 13c:	4c05                	li	s8,1
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 13e:	a099                	j	184 <grep+0x78>
      p = q+1;
 140:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 144:	85ce                	mv	a1,s3
 146:	854a                	mv	a0,s2
 148:	00000097          	auipc	ra,0x0
 14c:	220080e7          	jalr	544(ra) # 368 <strchr>
 150:	84aa                	mv	s1,a0
 152:	c51d                	beqz	a0,180 <grep+0x74>
      *q = 0;
 154:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 158:	85ca                	mv	a1,s2
 15a:	8556                	mv	a0,s5
 15c:	00000097          	auipc	ra,0x0
 160:	f62080e7          	jalr	-158(ra) # be <match>
 164:	dd71                	beqz	a0,140 <grep+0x34>
        *q = '\n';
 166:	01348023          	sb	s3,0(s1)
        write(1, p, q+1 - p);
 16a:	00148613          	addi	a2,s1,1
 16e:	4126063b          	subw	a2,a2,s2
 172:	85ca                	mv	a1,s2
 174:	8562                	mv	a0,s8
 176:	00000097          	auipc	ra,0x0
 17a:	3fe080e7          	jalr	1022(ra) # 574 <write>
 17e:	b7c9                	j	140 <grep+0x34>
    if(m > 0){
 180:	03604663          	bgtz	s6,1ac <grep+0xa0>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 184:	416d063b          	subw	a2,s10,s6
 188:	016b85b3          	add	a1,s7,s6
 18c:	8566                	mv	a0,s9
 18e:	00000097          	auipc	ra,0x0
 192:	3de080e7          	jalr	990(ra) # 56c <read>
 196:	02a05e63          	blez	a0,1d2 <grep+0xc6>
    m += n;
 19a:	00ab0a3b          	addw	s4,s6,a0
 19e:	8b52                	mv	s6,s4
    buf[m] = '\0';
 1a0:	014b87b3          	add	a5,s7,s4
 1a4:	00078023          	sb	zero,0(a5)
    p = buf;
 1a8:	895e                	mv	s2,s7
    while((q = strchr(p, '\n')) != 0){
 1aa:	bf69                	j	144 <grep+0x38>
      m -= p - buf;
 1ac:	00001797          	auipc	a5,0x1
 1b0:	47478793          	addi	a5,a5,1140 # 1620 <buf>
 1b4:	40f907b3          	sub	a5,s2,a5
 1b8:	40fa063b          	subw	a2,s4,a5
 1bc:	8b32                	mv	s6,a2
      memmove(buf, p, m);
 1be:	85ca                	mv	a1,s2
 1c0:	00001517          	auipc	a0,0x1
 1c4:	46050513          	addi	a0,a0,1120 # 1620 <buf>
 1c8:	00000097          	auipc	ra,0x0
 1cc:	2d6080e7          	jalr	726(ra) # 49e <memmove>
 1d0:	bf55                	j	184 <grep+0x78>
}
 1d2:	60e6                	ld	ra,88(sp)
 1d4:	6446                	ld	s0,80(sp)
 1d6:	64a6                	ld	s1,72(sp)
 1d8:	6906                	ld	s2,64(sp)
 1da:	79e2                	ld	s3,56(sp)
 1dc:	7a42                	ld	s4,48(sp)
 1de:	7aa2                	ld	s5,40(sp)
 1e0:	7b02                	ld	s6,32(sp)
 1e2:	6be2                	ld	s7,24(sp)
 1e4:	6c42                	ld	s8,16(sp)
 1e6:	6ca2                	ld	s9,8(sp)
 1e8:	6d02                	ld	s10,0(sp)
 1ea:	6125                	addi	sp,sp,96
 1ec:	8082                	ret

00000000000001ee <main>:
{
 1ee:	7179                	addi	sp,sp,-48
 1f0:	f406                	sd	ra,40(sp)
 1f2:	f022                	sd	s0,32(sp)
 1f4:	ec26                	sd	s1,24(sp)
 1f6:	e84a                	sd	s2,16(sp)
 1f8:	e44e                	sd	s3,8(sp)
 1fa:	e052                	sd	s4,0(sp)
 1fc:	1800                	addi	s0,sp,48
  if(argc <= 1){
 1fe:	4785                	li	a5,1
 200:	04a7de63          	bge	a5,a0,25c <main+0x6e>
  pattern = argv[1];
 204:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 208:	4789                	li	a5,2
 20a:	06a7d763          	bge	a5,a0,278 <main+0x8a>
 20e:	01058913          	addi	s2,a1,16
 212:	ffd5099b          	addiw	s3,a0,-3
 216:	02099793          	slli	a5,s3,0x20
 21a:	01d7d993          	srli	s3,a5,0x1d
 21e:	05e1                	addi	a1,a1,24
 220:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 222:	4581                	li	a1,0
 224:	00093503          	ld	a0,0(s2)
 228:	00000097          	auipc	ra,0x0
 22c:	36c080e7          	jalr	876(ra) # 594 <open>
 230:	84aa                	mv	s1,a0
 232:	04054e63          	bltz	a0,28e <main+0xa0>
    grep(pattern, fd);
 236:	85aa                	mv	a1,a0
 238:	8552                	mv	a0,s4
 23a:	00000097          	auipc	ra,0x0
 23e:	ed2080e7          	jalr	-302(ra) # 10c <grep>
    close(fd);
 242:	8526                	mv	a0,s1
 244:	00000097          	auipc	ra,0x0
 248:	338080e7          	jalr	824(ra) # 57c <close>
  for(i = 2; i < argc; i++){
 24c:	0921                	addi	s2,s2,8
 24e:	fd391ae3          	bne	s2,s3,222 <main+0x34>
  exit(0);
 252:	4501                	li	a0,0
 254:	00000097          	auipc	ra,0x0
 258:	300080e7          	jalr	768(ra) # 554 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25c:	00001597          	auipc	a1,0x1
 260:	a8458593          	addi	a1,a1,-1404 # ce0 <ithread_join+0x4a>
 264:	4509                	li	a0,2
 266:	00000097          	auipc	ra,0x0
 26a:	646080e7          	jalr	1606(ra) # 8ac <fprintf>
    exit(1);
 26e:	4505                	li	a0,1
 270:	00000097          	auipc	ra,0x0
 274:	2e4080e7          	jalr	740(ra) # 554 <exit>
    grep(pattern, 0);
 278:	4581                	li	a1,0
 27a:	8552                	mv	a0,s4
 27c:	00000097          	auipc	ra,0x0
 280:	e90080e7          	jalr	-368(ra) # 10c <grep>
    exit(0);
 284:	4501                	li	a0,0
 286:	00000097          	auipc	ra,0x0
 28a:	2ce080e7          	jalr	718(ra) # 554 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28e:	00093583          	ld	a1,0(s2)
 292:	00001517          	auipc	a0,0x1
 296:	a6e50513          	addi	a0,a0,-1426 # d00 <ithread_join+0x6a>
 29a:	00000097          	auipc	ra,0x0
 29e:	640080e7          	jalr	1600(ra) # 8da <printf>
      exit(1);
 2a2:	4505                	li	a0,1
 2a4:	00000097          	auipc	ra,0x0
 2a8:	2b0080e7          	jalr	688(ra) # 554 <exit>

00000000000002ac <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2ac:	1141                	addi	sp,sp,-16
 2ae:	e406                	sd	ra,8(sp)
 2b0:	e022                	sd	s0,0(sp)
 2b2:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2b4:	00000097          	auipc	ra,0x0
 2b8:	f3a080e7          	jalr	-198(ra) # 1ee <main>
  exit(0);
 2bc:	4501                	li	a0,0
 2be:	00000097          	auipc	ra,0x0
 2c2:	296080e7          	jalr	662(ra) # 554 <exit>

00000000000002c6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ce:	87aa                	mv	a5,a0
 2d0:	0585                	addi	a1,a1,1
 2d2:	0785                	addi	a5,a5,1
 2d4:	fff5c703          	lbu	a4,-1(a1)
 2d8:	fee78fa3          	sb	a4,-1(a5)
 2dc:	fb75                	bnez	a4,2d0 <strcpy+0xa>
    ;
  return os;
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2ee:	00054783          	lbu	a5,0(a0)
 2f2:	cb91                	beqz	a5,306 <strcmp+0x20>
 2f4:	0005c703          	lbu	a4,0(a1)
 2f8:	00f71763          	bne	a4,a5,306 <strcmp+0x20>
    p++, q++;
 2fc:	0505                	addi	a0,a0,1
 2fe:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 300:	00054783          	lbu	a5,0(a0)
 304:	fbe5                	bnez	a5,2f4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 306:	0005c503          	lbu	a0,0(a1)
}
 30a:	40a7853b          	subw	a0,a5,a0
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret

0000000000000316 <strlen>:

uint
strlen(const char *s)
{
 316:	1141                	addi	sp,sp,-16
 318:	e406                	sd	ra,8(sp)
 31a:	e022                	sd	s0,0(sp)
 31c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 31e:	00054783          	lbu	a5,0(a0)
 322:	cf91                	beqz	a5,33e <strlen+0x28>
 324:	00150793          	addi	a5,a0,1
 328:	86be                	mv	a3,a5
 32a:	0785                	addi	a5,a5,1
 32c:	fff7c703          	lbu	a4,-1(a5)
 330:	ff65                	bnez	a4,328 <strlen+0x12>
 332:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret
  for(n = 0; s[n]; n++)
 33e:	4501                	li	a0,0
 340:	bfdd                	j	336 <strlen+0x20>

0000000000000342 <memset>:

void*
memset(void *dst, int c, uint n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e406                	sd	ra,8(sp)
 346:	e022                	sd	s0,0(sp)
 348:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 34a:	ca19                	beqz	a2,360 <memset+0x1e>
 34c:	87aa                	mv	a5,a0
 34e:	1602                	slli	a2,a2,0x20
 350:	9201                	srli	a2,a2,0x20
 352:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 356:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 35a:	0785                	addi	a5,a5,1
 35c:	fee79de3          	bne	a5,a4,356 <memset+0x14>
  }
  return dst;
}
 360:	60a2                	ld	ra,8(sp)
 362:	6402                	ld	s0,0(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <strchr>:

char*
strchr(const char *s, char c)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e406                	sd	ra,8(sp)
 36c:	e022                	sd	s0,0(sp)
 36e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 370:	00054783          	lbu	a5,0(a0)
 374:	cf81                	beqz	a5,38c <strchr+0x24>
    if(*s == c)
 376:	00f58763          	beq	a1,a5,384 <strchr+0x1c>
  for(; *s; s++)
 37a:	0505                	addi	a0,a0,1
 37c:	00054783          	lbu	a5,0(a0)
 380:	fbfd                	bnez	a5,376 <strchr+0xe>
      return (char*)s;
  return 0;
 382:	4501                	li	a0,0
}
 384:	60a2                	ld	ra,8(sp)
 386:	6402                	ld	s0,0(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret
  return 0;
 38c:	4501                	li	a0,0
 38e:	bfdd                	j	384 <strchr+0x1c>

0000000000000390 <gets>:

char*
gets(char *buf, int max)
{
 390:	711d                	addi	sp,sp,-96
 392:	ec86                	sd	ra,88(sp)
 394:	e8a2                	sd	s0,80(sp)
 396:	e4a6                	sd	s1,72(sp)
 398:	e0ca                	sd	s2,64(sp)
 39a:	fc4e                	sd	s3,56(sp)
 39c:	f852                	sd	s4,48(sp)
 39e:	f456                	sd	s5,40(sp)
 3a0:	f05a                	sd	s6,32(sp)
 3a2:	ec5e                	sd	s7,24(sp)
 3a4:	e862                	sd	s8,16(sp)
 3a6:	1080                	addi	s0,sp,96
 3a8:	8baa                	mv	s7,a0
 3aa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ac:	892a                	mv	s2,a0
 3ae:	4481                	li	s1,0
    cc = read(0, &c, 1);
 3b0:	faf40b13          	addi	s6,s0,-81
 3b4:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 3b6:	8c26                	mv	s8,s1
 3b8:	0014899b          	addiw	s3,s1,1
 3bc:	84ce                	mv	s1,s3
 3be:	0349d663          	bge	s3,s4,3ea <gets+0x5a>
    cc = read(0, &c, 1);
 3c2:	8656                	mv	a2,s5
 3c4:	85da                	mv	a1,s6
 3c6:	4501                	li	a0,0
 3c8:	00000097          	auipc	ra,0x0
 3cc:	1a4080e7          	jalr	420(ra) # 56c <read>
    if(cc < 1)
 3d0:	00a05d63          	blez	a0,3ea <gets+0x5a>
      break;
    buf[i++] = c;
 3d4:	faf44783          	lbu	a5,-81(s0)
 3d8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3dc:	0905                	addi	s2,s2,1
 3de:	ff678713          	addi	a4,a5,-10
 3e2:	c319                	beqz	a4,3e8 <gets+0x58>
 3e4:	17cd                	addi	a5,a5,-13
 3e6:	fbe1                	bnez	a5,3b6 <gets+0x26>
    buf[i++] = c;
 3e8:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 3ea:	9c5e                	add	s8,s8,s7
 3ec:	000c0023          	sb	zero,0(s8)
  return buf;
}
 3f0:	855e                	mv	a0,s7
 3f2:	60e6                	ld	ra,88(sp)
 3f4:	6446                	ld	s0,80(sp)
 3f6:	64a6                	ld	s1,72(sp)
 3f8:	6906                	ld	s2,64(sp)
 3fa:	79e2                	ld	s3,56(sp)
 3fc:	7a42                	ld	s4,48(sp)
 3fe:	7aa2                	ld	s5,40(sp)
 400:	7b02                	ld	s6,32(sp)
 402:	6be2                	ld	s7,24(sp)
 404:	6c42                	ld	s8,16(sp)
 406:	6125                	addi	sp,sp,96
 408:	8082                	ret

000000000000040a <stat>:

int
stat(const char *n, struct stat *st)
{
 40a:	1101                	addi	sp,sp,-32
 40c:	ec06                	sd	ra,24(sp)
 40e:	e822                	sd	s0,16(sp)
 410:	e04a                	sd	s2,0(sp)
 412:	1000                	addi	s0,sp,32
 414:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 416:	4581                	li	a1,0
 418:	00000097          	auipc	ra,0x0
 41c:	17c080e7          	jalr	380(ra) # 594 <open>
  if(fd < 0)
 420:	02054663          	bltz	a0,44c <stat+0x42>
 424:	e426                	sd	s1,8(sp)
 426:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 428:	85ca                	mv	a1,s2
 42a:	00000097          	auipc	ra,0x0
 42e:	182080e7          	jalr	386(ra) # 5ac <fstat>
 432:	892a                	mv	s2,a0
  close(fd);
 434:	8526                	mv	a0,s1
 436:	00000097          	auipc	ra,0x0
 43a:	146080e7          	jalr	326(ra) # 57c <close>
  return r;
 43e:	64a2                	ld	s1,8(sp)
}
 440:	854a                	mv	a0,s2
 442:	60e2                	ld	ra,24(sp)
 444:	6442                	ld	s0,16(sp)
 446:	6902                	ld	s2,0(sp)
 448:	6105                	addi	sp,sp,32
 44a:	8082                	ret
    return -1;
 44c:	57fd                	li	a5,-1
 44e:	893e                	mv	s2,a5
 450:	bfc5                	j	440 <stat+0x36>

0000000000000452 <atoi>:

int
atoi(const char *s)
{
 452:	1141                	addi	sp,sp,-16
 454:	e406                	sd	ra,8(sp)
 456:	e022                	sd	s0,0(sp)
 458:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 45a:	00054683          	lbu	a3,0(a0)
 45e:	fd06879b          	addiw	a5,a3,-48
 462:	0ff7f793          	zext.b	a5,a5
 466:	4625                	li	a2,9
 468:	02f66963          	bltu	a2,a5,49a <atoi+0x48>
 46c:	872a                	mv	a4,a0
  n = 0;
 46e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 470:	0705                	addi	a4,a4,1
 472:	0025179b          	slliw	a5,a0,0x2
 476:	9fa9                	addw	a5,a5,a0
 478:	0017979b          	slliw	a5,a5,0x1
 47c:	9fb5                	addw	a5,a5,a3
 47e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 482:	00074683          	lbu	a3,0(a4)
 486:	fd06879b          	addiw	a5,a3,-48
 48a:	0ff7f793          	zext.b	a5,a5
 48e:	fef671e3          	bgeu	a2,a5,470 <atoi+0x1e>
  return n;
}
 492:	60a2                	ld	ra,8(sp)
 494:	6402                	ld	s0,0(sp)
 496:	0141                	addi	sp,sp,16
 498:	8082                	ret
  n = 0;
 49a:	4501                	li	a0,0
 49c:	bfdd                	j	492 <atoi+0x40>

000000000000049e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 49e:	1141                	addi	sp,sp,-16
 4a0:	e406                	sd	ra,8(sp)
 4a2:	e022                	sd	s0,0(sp)
 4a4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4a6:	02b57563          	bgeu	a0,a1,4d0 <memmove+0x32>
    while(n-- > 0)
 4aa:	00c05f63          	blez	a2,4c8 <memmove+0x2a>
 4ae:	1602                	slli	a2,a2,0x20
 4b0:	9201                	srli	a2,a2,0x20
 4b2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4b6:	872a                	mv	a4,a0
      *dst++ = *src++;
 4b8:	0585                	addi	a1,a1,1
 4ba:	0705                	addi	a4,a4,1
 4bc:	fff5c683          	lbu	a3,-1(a1)
 4c0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4c4:	fee79ae3          	bne	a5,a4,4b8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4c8:	60a2                	ld	ra,8(sp)
 4ca:	6402                	ld	s0,0(sp)
 4cc:	0141                	addi	sp,sp,16
 4ce:	8082                	ret
    while(n-- > 0)
 4d0:	fec05ce3          	blez	a2,4c8 <memmove+0x2a>
    dst += n;
 4d4:	00c50733          	add	a4,a0,a2
    src += n;
 4d8:	95b2                	add	a1,a1,a2
 4da:	fff6079b          	addiw	a5,a2,-1
 4de:	1782                	slli	a5,a5,0x20
 4e0:	9381                	srli	a5,a5,0x20
 4e2:	fff7c793          	not	a5,a5
 4e6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4e8:	15fd                	addi	a1,a1,-1
 4ea:	177d                	addi	a4,a4,-1
 4ec:	0005c683          	lbu	a3,0(a1)
 4f0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4f4:	fef71ae3          	bne	a4,a5,4e8 <memmove+0x4a>
 4f8:	bfc1                	j	4c8 <memmove+0x2a>

00000000000004fa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4fa:	1141                	addi	sp,sp,-16
 4fc:	e406                	sd	ra,8(sp)
 4fe:	e022                	sd	s0,0(sp)
 500:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 502:	c61d                	beqz	a2,530 <memcmp+0x36>
 504:	1602                	slli	a2,a2,0x20
 506:	9201                	srli	a2,a2,0x20
 508:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 50c:	00054783          	lbu	a5,0(a0)
 510:	0005c703          	lbu	a4,0(a1)
 514:	00e79863          	bne	a5,a4,524 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 518:	0505                	addi	a0,a0,1
    p2++;
 51a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 51c:	fed518e3          	bne	a0,a3,50c <memcmp+0x12>
  }
  return 0;
 520:	4501                	li	a0,0
 522:	a019                	j	528 <memcmp+0x2e>
      return *p1 - *p2;
 524:	40e7853b          	subw	a0,a5,a4
}
 528:	60a2                	ld	ra,8(sp)
 52a:	6402                	ld	s0,0(sp)
 52c:	0141                	addi	sp,sp,16
 52e:	8082                	ret
  return 0;
 530:	4501                	li	a0,0
 532:	bfdd                	j	528 <memcmp+0x2e>

0000000000000534 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 534:	1141                	addi	sp,sp,-16
 536:	e406                	sd	ra,8(sp)
 538:	e022                	sd	s0,0(sp)
 53a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 53c:	00000097          	auipc	ra,0x0
 540:	f62080e7          	jalr	-158(ra) # 49e <memmove>
}
 544:	60a2                	ld	ra,8(sp)
 546:	6402                	ld	s0,0(sp)
 548:	0141                	addi	sp,sp,16
 54a:	8082                	ret

000000000000054c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 54c:	4885                	li	a7,1
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <exit>:
.global exit
exit:
 li a7, SYS_exit
 554:	4889                	li	a7,2
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <wait>:
.global wait
wait:
 li a7, SYS_wait
 55c:	488d                	li	a7,3
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 564:	4891                	li	a7,4
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <read>:
.global read
read:
 li a7, SYS_read
 56c:	4895                	li	a7,5
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <write>:
.global write
write:
 li a7, SYS_write
 574:	48c1                	li	a7,16
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <close>:
.global close
close:
 li a7, SYS_close
 57c:	48d5                	li	a7,21
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <kill>:
.global kill
kill:
 li a7, SYS_kill
 584:	4899                	li	a7,6
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <exec>:
.global exec
exec:
 li a7, SYS_exec
 58c:	489d                	li	a7,7
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <open>:
.global open
open:
 li a7, SYS_open
 594:	48bd                	li	a7,15
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 59c:	48c5                	li	a7,17
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5a4:	48c9                	li	a7,18
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ac:	48a1                	li	a7,8
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <link>:
.global link
link:
 li a7, SYS_link
 5b4:	48cd                	li	a7,19
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5bc:	48d1                	li	a7,20
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5c4:	48a5                	li	a7,9
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <dup>:
.global dup
dup:
 li a7, SYS_dup
 5cc:	48a9                	li	a7,10
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5d4:	48ad                	li	a7,11
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5dc:	48b1                	li	a7,12
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5e4:	48b5                	li	a7,13
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5ec:	48b9                	li	a7,14
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <spoon>:
.global spoon
spoon:
 li a7, SYS_spoon
 5f4:	48d9                	li	a7,22
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <create_thread>:
.global create_thread
create_thread:
 li a7, SYS_create_thread
 5fc:	48dd                	li	a7,23
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <join_thread>:
.global join_thread
join_thread:
 li a7, SYS_join_thread
 604:	48e1                	li	a7,24
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
 60c:	48e5                	li	a7,25
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 614:	1101                	addi	sp,sp,-32
 616:	ec06                	sd	ra,24(sp)
 618:	e822                	sd	s0,16(sp)
 61a:	1000                	addi	s0,sp,32
 61c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 620:	4605                	li	a2,1
 622:	fef40593          	addi	a1,s0,-17
 626:	00000097          	auipc	ra,0x0
 62a:	f4e080e7          	jalr	-178(ra) # 574 <write>
}
 62e:	60e2                	ld	ra,24(sp)
 630:	6442                	ld	s0,16(sp)
 632:	6105                	addi	sp,sp,32
 634:	8082                	ret

0000000000000636 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 636:	7139                	addi	sp,sp,-64
 638:	fc06                	sd	ra,56(sp)
 63a:	f822                	sd	s0,48(sp)
 63c:	f04a                	sd	s2,32(sp)
 63e:	ec4e                	sd	s3,24(sp)
 640:	0080                	addi	s0,sp,64
 642:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 644:	cad9                	beqz	a3,6da <printint+0xa4>
 646:	01f5d79b          	srliw	a5,a1,0x1f
 64a:	cbc1                	beqz	a5,6da <printint+0xa4>
    neg = 1;
    x = -xx;
 64c:	40b005bb          	negw	a1,a1
    neg = 1;
 650:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 652:	fc040993          	addi	s3,s0,-64
  neg = 0;
 656:	86ce                	mv	a3,s3
  i = 0;
 658:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 65a:	00000817          	auipc	a6,0x0
 65e:	74e80813          	addi	a6,a6,1870 # da8 <digits>
 662:	88ba                	mv	a7,a4
 664:	0017051b          	addiw	a0,a4,1
 668:	872a                	mv	a4,a0
 66a:	02c5f7bb          	remuw	a5,a1,a2
 66e:	1782                	slli	a5,a5,0x20
 670:	9381                	srli	a5,a5,0x20
 672:	97c2                	add	a5,a5,a6
 674:	0007c783          	lbu	a5,0(a5)
 678:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 67c:	87ae                	mv	a5,a1
 67e:	02c5d5bb          	divuw	a1,a1,a2
 682:	0685                	addi	a3,a3,1
 684:	fcc7ffe3          	bgeu	a5,a2,662 <printint+0x2c>
  if(neg)
 688:	00030c63          	beqz	t1,6a0 <printint+0x6a>
    buf[i++] = '-';
 68c:	fd050793          	addi	a5,a0,-48
 690:	00878533          	add	a0,a5,s0
 694:	02d00793          	li	a5,45
 698:	fef50823          	sb	a5,-16(a0)
 69c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 6a0:	02e05763          	blez	a4,6ce <printint+0x98>
 6a4:	f426                	sd	s1,40(sp)
 6a6:	377d                	addiw	a4,a4,-1
 6a8:	00e984b3          	add	s1,s3,a4
 6ac:	19fd                	addi	s3,s3,-1
 6ae:	99ba                	add	s3,s3,a4
 6b0:	1702                	slli	a4,a4,0x20
 6b2:	9301                	srli	a4,a4,0x20
 6b4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6b8:	0004c583          	lbu	a1,0(s1)
 6bc:	854a                	mv	a0,s2
 6be:	00000097          	auipc	ra,0x0
 6c2:	f56080e7          	jalr	-170(ra) # 614 <putc>
  while(--i >= 0)
 6c6:	14fd                	addi	s1,s1,-1
 6c8:	ff3498e3          	bne	s1,s3,6b8 <printint+0x82>
 6cc:	74a2                	ld	s1,40(sp)
}
 6ce:	70e2                	ld	ra,56(sp)
 6d0:	7442                	ld	s0,48(sp)
 6d2:	7902                	ld	s2,32(sp)
 6d4:	69e2                	ld	s3,24(sp)
 6d6:	6121                	addi	sp,sp,64
 6d8:	8082                	ret
  neg = 0;
 6da:	4301                	li	t1,0
 6dc:	bf9d                	j	652 <printint+0x1c>

00000000000006de <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6de:	715d                	addi	sp,sp,-80
 6e0:	e486                	sd	ra,72(sp)
 6e2:	e0a2                	sd	s0,64(sp)
 6e4:	f84a                	sd	s2,48(sp)
 6e6:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6e8:	0005c903          	lbu	s2,0(a1)
 6ec:	1a090b63          	beqz	s2,8a2 <vprintf+0x1c4>
 6f0:	fc26                	sd	s1,56(sp)
 6f2:	f44e                	sd	s3,40(sp)
 6f4:	f052                	sd	s4,32(sp)
 6f6:	ec56                	sd	s5,24(sp)
 6f8:	e85a                	sd	s6,16(sp)
 6fa:	e45e                	sd	s7,8(sp)
 6fc:	8aaa                	mv	s5,a0
 6fe:	8bb2                	mv	s7,a2
 700:	00158493          	addi	s1,a1,1
  state = 0;
 704:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 706:	02500a13          	li	s4,37
 70a:	4b55                	li	s6,21
 70c:	a839                	j	72a <vprintf+0x4c>
        putc(fd, c);
 70e:	85ca                	mv	a1,s2
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	f02080e7          	jalr	-254(ra) # 614 <putc>
 71a:	a019                	j	720 <vprintf+0x42>
    } else if(state == '%'){
 71c:	01498d63          	beq	s3,s4,736 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 720:	0485                	addi	s1,s1,1
 722:	fff4c903          	lbu	s2,-1(s1)
 726:	16090863          	beqz	s2,896 <vprintf+0x1b8>
    if(state == 0){
 72a:	fe0999e3          	bnez	s3,71c <vprintf+0x3e>
      if(c == '%'){
 72e:	ff4910e3          	bne	s2,s4,70e <vprintf+0x30>
        state = '%';
 732:	89d2                	mv	s3,s4
 734:	b7f5                	j	720 <vprintf+0x42>
      if(c == 'd'){
 736:	13490563          	beq	s2,s4,860 <vprintf+0x182>
 73a:	f9d9079b          	addiw	a5,s2,-99
 73e:	0ff7f793          	zext.b	a5,a5
 742:	12fb6863          	bltu	s6,a5,872 <vprintf+0x194>
 746:	f9d9079b          	addiw	a5,s2,-99
 74a:	0ff7f713          	zext.b	a4,a5
 74e:	12eb6263          	bltu	s6,a4,872 <vprintf+0x194>
 752:	00271793          	slli	a5,a4,0x2
 756:	00000717          	auipc	a4,0x0
 75a:	5fa70713          	addi	a4,a4,1530 # d50 <ithread_join+0xba>
 75e:	97ba                	add	a5,a5,a4
 760:	439c                	lw	a5,0(a5)
 762:	97ba                	add	a5,a5,a4
 764:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 766:	008b8913          	addi	s2,s7,8
 76a:	4685                	li	a3,1
 76c:	4629                	li	a2,10
 76e:	000ba583          	lw	a1,0(s7)
 772:	8556                	mv	a0,s5
 774:	00000097          	auipc	ra,0x0
 778:	ec2080e7          	jalr	-318(ra) # 636 <printint>
 77c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 77e:	4981                	li	s3,0
 780:	b745                	j	720 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 782:	008b8913          	addi	s2,s7,8
 786:	4681                	li	a3,0
 788:	4629                	li	a2,10
 78a:	000ba583          	lw	a1,0(s7)
 78e:	8556                	mv	a0,s5
 790:	00000097          	auipc	ra,0x0
 794:	ea6080e7          	jalr	-346(ra) # 636 <printint>
 798:	8bca                	mv	s7,s2
      state = 0;
 79a:	4981                	li	s3,0
 79c:	b751                	j	720 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 79e:	008b8913          	addi	s2,s7,8
 7a2:	4681                	li	a3,0
 7a4:	4641                	li	a2,16
 7a6:	000ba583          	lw	a1,0(s7)
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	e8a080e7          	jalr	-374(ra) # 636 <printint>
 7b4:	8bca                	mv	s7,s2
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b7a5                	j	720 <vprintf+0x42>
 7ba:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7bc:	008b8793          	addi	a5,s7,8
 7c0:	8c3e                	mv	s8,a5
 7c2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7c6:	03000593          	li	a1,48
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	e48080e7          	jalr	-440(ra) # 614 <putc>
  putc(fd, 'x');
 7d4:	07800593          	li	a1,120
 7d8:	8556                	mv	a0,s5
 7da:	00000097          	auipc	ra,0x0
 7de:	e3a080e7          	jalr	-454(ra) # 614 <putc>
 7e2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7e4:	00000b97          	auipc	s7,0x0
 7e8:	5c4b8b93          	addi	s7,s7,1476 # da8 <digits>
 7ec:	03c9d793          	srli	a5,s3,0x3c
 7f0:	97de                	add	a5,a5,s7
 7f2:	0007c583          	lbu	a1,0(a5)
 7f6:	8556                	mv	a0,s5
 7f8:	00000097          	auipc	ra,0x0
 7fc:	e1c080e7          	jalr	-484(ra) # 614 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 800:	0992                	slli	s3,s3,0x4
 802:	397d                	addiw	s2,s2,-1
 804:	fe0914e3          	bnez	s2,7ec <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 808:	8be2                	mv	s7,s8
      state = 0;
 80a:	4981                	li	s3,0
 80c:	6c02                	ld	s8,0(sp)
 80e:	bf09                	j	720 <vprintf+0x42>
        s = va_arg(ap, char*);
 810:	008b8993          	addi	s3,s7,8
 814:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 818:	02090163          	beqz	s2,83a <vprintf+0x15c>
        while(*s != 0){
 81c:	00094583          	lbu	a1,0(s2)
 820:	c9a5                	beqz	a1,890 <vprintf+0x1b2>
          putc(fd, *s);
 822:	8556                	mv	a0,s5
 824:	00000097          	auipc	ra,0x0
 828:	df0080e7          	jalr	-528(ra) # 614 <putc>
          s++;
 82c:	0905                	addi	s2,s2,1
        while(*s != 0){
 82e:	00094583          	lbu	a1,0(s2)
 832:	f9e5                	bnez	a1,822 <vprintf+0x144>
        s = va_arg(ap, char*);
 834:	8bce                	mv	s7,s3
      state = 0;
 836:	4981                	li	s3,0
 838:	b5e5                	j	720 <vprintf+0x42>
          s = "(null)";
 83a:	00000917          	auipc	s2,0x0
 83e:	4de90913          	addi	s2,s2,1246 # d18 <ithread_join+0x82>
        while(*s != 0){
 842:	02800593          	li	a1,40
 846:	bff1                	j	822 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 848:	008b8913          	addi	s2,s7,8
 84c:	000bc583          	lbu	a1,0(s7)
 850:	8556                	mv	a0,s5
 852:	00000097          	auipc	ra,0x0
 856:	dc2080e7          	jalr	-574(ra) # 614 <putc>
 85a:	8bca                	mv	s7,s2
      state = 0;
 85c:	4981                	li	s3,0
 85e:	b5c9                	j	720 <vprintf+0x42>
        putc(fd, c);
 860:	02500593          	li	a1,37
 864:	8556                	mv	a0,s5
 866:	00000097          	auipc	ra,0x0
 86a:	dae080e7          	jalr	-594(ra) # 614 <putc>
      state = 0;
 86e:	4981                	li	s3,0
 870:	bd45                	j	720 <vprintf+0x42>
        putc(fd, '%');
 872:	02500593          	li	a1,37
 876:	8556                	mv	a0,s5
 878:	00000097          	auipc	ra,0x0
 87c:	d9c080e7          	jalr	-612(ra) # 614 <putc>
        putc(fd, c);
 880:	85ca                	mv	a1,s2
 882:	8556                	mv	a0,s5
 884:	00000097          	auipc	ra,0x0
 888:	d90080e7          	jalr	-624(ra) # 614 <putc>
      state = 0;
 88c:	4981                	li	s3,0
 88e:	bd49                	j	720 <vprintf+0x42>
        s = va_arg(ap, char*);
 890:	8bce                	mv	s7,s3
      state = 0;
 892:	4981                	li	s3,0
 894:	b571                	j	720 <vprintf+0x42>
 896:	74e2                	ld	s1,56(sp)
 898:	79a2                	ld	s3,40(sp)
 89a:	7a02                	ld	s4,32(sp)
 89c:	6ae2                	ld	s5,24(sp)
 89e:	6b42                	ld	s6,16(sp)
 8a0:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8a2:	60a6                	ld	ra,72(sp)
 8a4:	6406                	ld	s0,64(sp)
 8a6:	7942                	ld	s2,48(sp)
 8a8:	6161                	addi	sp,sp,80
 8aa:	8082                	ret

00000000000008ac <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8ac:	715d                	addi	sp,sp,-80
 8ae:	ec06                	sd	ra,24(sp)
 8b0:	e822                	sd	s0,16(sp)
 8b2:	1000                	addi	s0,sp,32
 8b4:	e010                	sd	a2,0(s0)
 8b6:	e414                	sd	a3,8(s0)
 8b8:	e818                	sd	a4,16(s0)
 8ba:	ec1c                	sd	a5,24(s0)
 8bc:	03043023          	sd	a6,32(s0)
 8c0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8c4:	8622                	mv	a2,s0
 8c6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8ca:	00000097          	auipc	ra,0x0
 8ce:	e14080e7          	jalr	-492(ra) # 6de <vprintf>
}
 8d2:	60e2                	ld	ra,24(sp)
 8d4:	6442                	ld	s0,16(sp)
 8d6:	6161                	addi	sp,sp,80
 8d8:	8082                	ret

00000000000008da <printf>:

void
printf(const char *fmt, ...)
{
 8da:	711d                	addi	sp,sp,-96
 8dc:	ec06                	sd	ra,24(sp)
 8de:	e822                	sd	s0,16(sp)
 8e0:	1000                	addi	s0,sp,32
 8e2:	e40c                	sd	a1,8(s0)
 8e4:	e810                	sd	a2,16(s0)
 8e6:	ec14                	sd	a3,24(s0)
 8e8:	f018                	sd	a4,32(s0)
 8ea:	f41c                	sd	a5,40(s0)
 8ec:	03043823          	sd	a6,48(s0)
 8f0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8f4:	00840613          	addi	a2,s0,8
 8f8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8fc:	85aa                	mv	a1,a0
 8fe:	4505                	li	a0,1
 900:	00000097          	auipc	ra,0x0
 904:	dde080e7          	jalr	-546(ra) # 6de <vprintf>
}
 908:	60e2                	ld	ra,24(sp)
 90a:	6442                	ld	s0,16(sp)
 90c:	6125                	addi	sp,sp,96
 90e:	8082                	ret

0000000000000910 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 910:	1141                	addi	sp,sp,-16
 912:	e406                	sd	ra,8(sp)
 914:	e022                	sd	s0,0(sp)
 916:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 918:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91c:	00001797          	auipc	a5,0x1
 920:	ce47b783          	ld	a5,-796(a5) # 1600 <freep>
 924:	a039                	j	932 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 926:	6398                	ld	a4,0(a5)
 928:	00e7e463          	bltu	a5,a4,930 <free+0x20>
 92c:	00e6ea63          	bltu	a3,a4,940 <free+0x30>
{
 930:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 932:	fed7fae3          	bgeu	a5,a3,926 <free+0x16>
 936:	6398                	ld	a4,0(a5)
 938:	00e6e463          	bltu	a3,a4,940 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 93c:	fee7eae3          	bltu	a5,a4,930 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 940:	ff852583          	lw	a1,-8(a0)
 944:	6390                	ld	a2,0(a5)
 946:	02059813          	slli	a6,a1,0x20
 94a:	01c85713          	srli	a4,a6,0x1c
 94e:	9736                	add	a4,a4,a3
 950:	02e60563          	beq	a2,a4,97a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 954:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 958:	4790                	lw	a2,8(a5)
 95a:	02061593          	slli	a1,a2,0x20
 95e:	01c5d713          	srli	a4,a1,0x1c
 962:	973e                	add	a4,a4,a5
 964:	02e68263          	beq	a3,a4,988 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 968:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 96a:	00001717          	auipc	a4,0x1
 96e:	c8f73b23          	sd	a5,-874(a4) # 1600 <freep>
}
 972:	60a2                	ld	ra,8(sp)
 974:	6402                	ld	s0,0(sp)
 976:	0141                	addi	sp,sp,16
 978:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 97a:	4618                	lw	a4,8(a2)
 97c:	9f2d                	addw	a4,a4,a1
 97e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 982:	6398                	ld	a4,0(a5)
 984:	6310                	ld	a2,0(a4)
 986:	b7f9                	j	954 <free+0x44>
    p->s.size += bp->s.size;
 988:	ff852703          	lw	a4,-8(a0)
 98c:	9f31                	addw	a4,a4,a2
 98e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 990:	ff053683          	ld	a3,-16(a0)
 994:	bfd1                	j	968 <free+0x58>

0000000000000996 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 996:	7139                	addi	sp,sp,-64
 998:	fc06                	sd	ra,56(sp)
 99a:	f822                	sd	s0,48(sp)
 99c:	f04a                	sd	s2,32(sp)
 99e:	ec4e                	sd	s3,24(sp)
 9a0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a2:	02051993          	slli	s3,a0,0x20
 9a6:	0209d993          	srli	s3,s3,0x20
 9aa:	09bd                	addi	s3,s3,15
 9ac:	0049d993          	srli	s3,s3,0x4
 9b0:	2985                	addiw	s3,s3,1
 9b2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9b4:	00001517          	auipc	a0,0x1
 9b8:	c4c53503          	ld	a0,-948(a0) # 1600 <freep>
 9bc:	c905                	beqz	a0,9ec <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9c0:	4798                	lw	a4,8(a5)
 9c2:	09377a63          	bgeu	a4,s3,a56 <malloc+0xc0>
 9c6:	f426                	sd	s1,40(sp)
 9c8:	e852                	sd	s4,16(sp)
 9ca:	e456                	sd	s5,8(sp)
 9cc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9ce:	8a4e                	mv	s4,s3
 9d0:	6705                	lui	a4,0x1
 9d2:	00e9f363          	bgeu	s3,a4,9d8 <malloc+0x42>
 9d6:	6a05                	lui	s4,0x1
 9d8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9dc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9e0:	00001497          	auipc	s1,0x1
 9e4:	c2048493          	addi	s1,s1,-992 # 1600 <freep>
  if(p == (char*)-1)
 9e8:	5afd                	li	s5,-1
 9ea:	a089                	j	a2c <malloc+0x96>
 9ec:	f426                	sd	s1,40(sp)
 9ee:	e852                	sd	s4,16(sp)
 9f0:	e456                	sd	s5,8(sp)
 9f2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9f4:	00001797          	auipc	a5,0x1
 9f8:	02c78793          	addi	a5,a5,44 # 1a20 <base>
 9fc:	00001717          	auipc	a4,0x1
 a00:	c0f73223          	sd	a5,-1020(a4) # 1600 <freep>
 a04:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a06:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a0a:	b7d1                	j	9ce <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a0c:	6398                	ld	a4,0(a5)
 a0e:	e118                	sd	a4,0(a0)
 a10:	a8b9                	j	a6e <malloc+0xd8>
  hp->s.size = nu;
 a12:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a16:	0541                	addi	a0,a0,16
 a18:	00000097          	auipc	ra,0x0
 a1c:	ef8080e7          	jalr	-264(ra) # 910 <free>
  return freep;
 a20:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a22:	c135                	beqz	a0,a86 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a24:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a26:	4798                	lw	a4,8(a5)
 a28:	03277363          	bgeu	a4,s2,a4e <malloc+0xb8>
    if(p == freep)
 a2c:	6098                	ld	a4,0(s1)
 a2e:	853e                	mv	a0,a5
 a30:	fef71ae3          	bne	a4,a5,a24 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a34:	8552                	mv	a0,s4
 a36:	00000097          	auipc	ra,0x0
 a3a:	ba6080e7          	jalr	-1114(ra) # 5dc <sbrk>
  if(p == (char*)-1)
 a3e:	fd551ae3          	bne	a0,s5,a12 <malloc+0x7c>
        return 0;
 a42:	4501                	li	a0,0
 a44:	74a2                	ld	s1,40(sp)
 a46:	6a42                	ld	s4,16(sp)
 a48:	6aa2                	ld	s5,8(sp)
 a4a:	6b02                	ld	s6,0(sp)
 a4c:	a03d                	j	a7a <malloc+0xe4>
 a4e:	74a2                	ld	s1,40(sp)
 a50:	6a42                	ld	s4,16(sp)
 a52:	6aa2                	ld	s5,8(sp)
 a54:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a56:	fae90be3          	beq	s2,a4,a0c <malloc+0x76>
        p->s.size -= nunits;
 a5a:	4137073b          	subw	a4,a4,s3
 a5e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a60:	02071693          	slli	a3,a4,0x20
 a64:	01c6d713          	srli	a4,a3,0x1c
 a68:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a6a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a6e:	00001717          	auipc	a4,0x1
 a72:	b8a73923          	sd	a0,-1134(a4) # 1600 <freep>
      return (void*)(p + 1);
 a76:	01078513          	addi	a0,a5,16
  }
}
 a7a:	70e2                	ld	ra,56(sp)
 a7c:	7442                	ld	s0,48(sp)
 a7e:	7902                	ld	s2,32(sp)
 a80:	69e2                	ld	s3,24(sp)
 a82:	6121                	addi	sp,sp,64
 a84:	8082                	ret
 a86:	74a2                	ld	s1,40(sp)
 a88:	6a42                	ld	s4,16(sp)
 a8a:	6aa2                	ld	s5,8(sp)
 a8c:	6b02                	ld	s6,0(sp)
 a8e:	b7f5                	j	a7a <malloc+0xe4>

0000000000000a90 <ithread_exit>:
  free(stacks);
  stacks = new_stacks;
  return 0;
}

void ithread_exit(uint64 status) {
 a90:	1141                	addi	sp,sp,-16
 a92:	e406                	sd	ra,8(sp)
 a94:	e022                	sd	s0,0(sp)
 a96:	0800                	addi	s0,sp,16
  thread_exit(status);
 a98:	00000097          	auipc	ra,0x0
 a9c:	b74080e7          	jalr	-1164(ra) # 60c <thread_exit>
}
 aa0:	60a2                	ld	ra,8(sp)
 aa2:	6402                	ld	s0,0(sp)
 aa4:	0141                	addi	sp,sp,16
 aa6:	8082                	ret

0000000000000aa8 <free_stacks>:
int free_stacks() {
 aa8:	7179                	addi	sp,sp,-48
 aaa:	f406                	sd	ra,40(sp)
 aac:	f022                	sd	s0,32(sp)
 aae:	ec26                	sd	s1,24(sp)
 ab0:	1800                	addi	s0,sp,48
  for (int i = 0; i < num_threads; i++) {
 ab2:	00001797          	auipc	a5,0x1
 ab6:	b5e7a783          	lw	a5,-1186(a5) # 1610 <num_threads>
 aba:	04f05063          	blez	a5,afa <free_stacks+0x52>
 abe:	e84a                	sd	s2,16(sp)
 ac0:	e44e                	sd	s3,8(sp)
 ac2:	4481                	li	s1,0
    free(stacks[i]);
 ac4:	00001997          	auipc	s3,0x1
 ac8:	b4498993          	addi	s3,s3,-1212 # 1608 <stacks>
  for (int i = 0; i < num_threads; i++) {
 acc:	00001917          	auipc	s2,0x1
 ad0:	b4490913          	addi	s2,s2,-1212 # 1610 <num_threads>
    free(stacks[i]);
 ad4:	0009b783          	ld	a5,0(s3)
 ad8:	00349713          	slli	a4,s1,0x3
 adc:	97ba                	add	a5,a5,a4
 ade:	6388                	ld	a0,0(a5)
 ae0:	00000097          	auipc	ra,0x0
 ae4:	e30080e7          	jalr	-464(ra) # 910 <free>
  for (int i = 0; i < num_threads; i++) {
 ae8:	0485                	addi	s1,s1,1
 aea:	00092703          	lw	a4,0(s2)
 aee:	0004879b          	sext.w	a5,s1
 af2:	fee7c1e3          	blt	a5,a4,ad4 <free_stacks+0x2c>
 af6:	6942                	ld	s2,16(sp)
 af8:	69a2                	ld	s3,8(sp)
  free(stacks);
 afa:	00001497          	auipc	s1,0x1
 afe:	b0e48493          	addi	s1,s1,-1266 # 1608 <stacks>
 b02:	6088                	ld	a0,0(s1)
 b04:	00000097          	auipc	ra,0x0
 b08:	e0c080e7          	jalr	-500(ra) # 910 <free>
  stacks = 0;
 b0c:	0004b023          	sd	zero,0(s1)
  num_threads = 0;
 b10:	00001797          	auipc	a5,0x1
 b14:	b007a023          	sw	zero,-1280(a5) # 1610 <num_threads>
  max_stacks = INIT_MAX_STACKS;
 b18:	47a1                	li	a5,8
 b1a:	00001717          	auipc	a4,0x1
 b1e:	acf72b23          	sw	a5,-1322(a4) # 15f0 <max_stacks>
  threads_done = 0;
 b22:	00001797          	auipc	a5,0x1
 b26:	ae07a923          	sw	zero,-1294(a5) # 1614 <threads_done>
}
 b2a:	4501                	li	a0,0
 b2c:	70a2                	ld	ra,40(sp)
 b2e:	7402                	ld	s0,32(sp)
 b30:	64e2                	ld	s1,24(sp)
 b32:	6145                	addi	sp,sp,48
 b34:	8082                	ret

0000000000000b36 <expand_num_threads>:
int expand_num_threads() {
 b36:	1101                	addi	sp,sp,-32
 b38:	ec06                	sd	ra,24(sp)
 b3a:	e822                	sd	s0,16(sp)
 b3c:	e426                	sd	s1,8(sp)
 b3e:	e04a                	sd	s2,0(sp)
 b40:	1000                	addi	s0,sp,32
  max_stacks *= 2;
 b42:	00001797          	auipc	a5,0x1
 b46:	aae78793          	addi	a5,a5,-1362 # 15f0 <max_stacks>
 b4a:	4388                	lw	a0,0(a5)
 b4c:	0015151b          	slliw	a0,a0,0x1
 b50:	c388                	sw	a0,0(a5)
  void **new_stacks = malloc(max_stacks*sizeof(char*));
 b52:	0035151b          	slliw	a0,a0,0x3
 b56:	00000097          	auipc	ra,0x0
 b5a:	e40080e7          	jalr	-448(ra) # 996 <malloc>
 b5e:	892a                	mv	s2,a0
  memmove(new_stacks, stacks, num_threads*sizeof(char*));
 b60:	00001617          	auipc	a2,0x1
 b64:	ab062603          	lw	a2,-1360(a2) # 1610 <num_threads>
 b68:	00001497          	auipc	s1,0x1
 b6c:	aa048493          	addi	s1,s1,-1376 # 1608 <stacks>
 b70:	0036161b          	slliw	a2,a2,0x3
 b74:	608c                	ld	a1,0(s1)
 b76:	00000097          	auipc	ra,0x0
 b7a:	928080e7          	jalr	-1752(ra) # 49e <memmove>
  free(stacks);
 b7e:	6088                	ld	a0,0(s1)
 b80:	00000097          	auipc	ra,0x0
 b84:	d90080e7          	jalr	-624(ra) # 910 <free>
  stacks = new_stacks;
 b88:	0124b023          	sd	s2,0(s1)
}
 b8c:	4501                	li	a0,0
 b8e:	60e2                	ld	ra,24(sp)
 b90:	6442                	ld	s0,16(sp)
 b92:	64a2                	ld	s1,8(sp)
 b94:	6902                	ld	s2,0(sp)
 b96:	6105                	addi	sp,sp,32
 b98:	8082                	ret

0000000000000b9a <ithread_create>:

int ithread_create(void* (*fn_ptr)(void *), void *args) {
 b9a:	7179                	addi	sp,sp,-48
 b9c:	f406                	sd	ra,40(sp)
 b9e:	f022                	sd	s0,32(sp)
 ba0:	e84a                	sd	s2,16(sp)
 ba2:	e44e                	sd	s3,8(sp)
 ba4:	1800                	addi	s0,sp,48
 ba6:	892a                	mv	s2,a0
 ba8:	89ae                	mv	s3,a1
  if (stacks == 0) {
 baa:	00001797          	auipc	a5,0x1
 bae:	a5e7b783          	ld	a5,-1442(a5) # 1608 <stacks>
 bb2:	c3d9                	beqz	a5,c38 <ithread_create+0x9e>
    stacks = malloc(max_stacks*sizeof(char*));
  }
  if (num_threads == max_stacks) {
 bb4:	00001797          	auipc	a5,0x1
 bb8:	a3c7a783          	lw	a5,-1476(a5) # 15f0 <max_stacks>
 bbc:	00001717          	auipc	a4,0x1
 bc0:	a5472703          	lw	a4,-1452(a4) # 1610 <num_threads>
 bc4:	0af71463          	bne	a4,a5,c6c <ithread_create+0xd2>
    if (max_stacks == MAX_THREADS) {
 bc8:	04000713          	li	a4,64
 bcc:	08e78563          	beq	a5,a4,c56 <ithread_create+0xbc>
 bd0:	ec26                	sd	s1,24(sp)
      printf("ERROR: Thread capacity has been reached\n");
      return -1;
    }
    expand_num_threads();
 bd2:	00000097          	auipc	ra,0x0
 bd6:	f64080e7          	jalr	-156(ra) # b36 <expand_num_threads>
  }

  void *stack_ptr = malloc(PGSIZE);
 bda:	6505                	lui	a0,0x1
 bdc:	00000097          	auipc	ra,0x0
 be0:	dba080e7          	jalr	-582(ra) # 996 <malloc>
 be4:	84aa                	mv	s1,a0
  stacks[num_threads] = stack_ptr;
 be6:	00001717          	auipc	a4,0x1
 bea:	a2a72703          	lw	a4,-1494(a4) # 1610 <num_threads>
 bee:	070e                	slli	a4,a4,0x3
 bf0:	00001797          	auipc	a5,0x1
 bf4:	a187b783          	ld	a5,-1512(a5) # 1608 <stacks>
 bf8:	97ba                	add	a5,a5,a4
 bfa:	e388                	sd	a0,0(a5)
  int res = create_thread(fn_ptr, args, stack_ptr, &ithread_exit);
 bfc:	00000697          	auipc	a3,0x0
 c00:	e9468693          	addi	a3,a3,-364 # a90 <ithread_exit>
 c04:	862a                	mv	a2,a0
 c06:	85ce                	mv	a1,s3
 c08:	854a                	mv	a0,s2
 c0a:	00000097          	auipc	ra,0x0
 c0e:	9f2080e7          	jalr	-1550(ra) # 5fc <create_thread>
 c12:	892a                	mv	s2,a0
  if (res != -1) {
 c14:	57fd                	li	a5,-1
 c16:	04f50d63          	beq	a0,a5,c70 <ithread_create+0xd6>
    num_threads++;
 c1a:	00001717          	auipc	a4,0x1
 c1e:	9f670713          	addi	a4,a4,-1546 # 1610 <num_threads>
 c22:	431c                	lw	a5,0(a4)
 c24:	2785                	addiw	a5,a5,1
 c26:	c31c                	sw	a5,0(a4)
 c28:	64e2                	ld	s1,24(sp)
  } else {
    free(stack_ptr);
    stacks[num_threads] = 0;
  }
  return res;
}
 c2a:	854a                	mv	a0,s2
 c2c:	70a2                	ld	ra,40(sp)
 c2e:	7402                	ld	s0,32(sp)
 c30:	6942                	ld	s2,16(sp)
 c32:	69a2                	ld	s3,8(sp)
 c34:	6145                	addi	sp,sp,48
 c36:	8082                	ret
    stacks = malloc(max_stacks*sizeof(char*));
 c38:	00001517          	auipc	a0,0x1
 c3c:	9b852503          	lw	a0,-1608(a0) # 15f0 <max_stacks>
 c40:	0035151b          	slliw	a0,a0,0x3
 c44:	00000097          	auipc	ra,0x0
 c48:	d52080e7          	jalr	-686(ra) # 996 <malloc>
 c4c:	00001797          	auipc	a5,0x1
 c50:	9aa7be23          	sd	a0,-1604(a5) # 1608 <stacks>
 c54:	b785                	j	bb4 <ithread_create+0x1a>
      printf("ERROR: Thread capacity has been reached\n");
 c56:	00000517          	auipc	a0,0x0
 c5a:	0ca50513          	addi	a0,a0,202 # d20 <ithread_join+0x8a>
 c5e:	00000097          	auipc	ra,0x0
 c62:	c7c080e7          	jalr	-900(ra) # 8da <printf>
      return -1;
 c66:	57fd                	li	a5,-1
 c68:	893e                	mv	s2,a5
 c6a:	b7c1                	j	c2a <ithread_create+0x90>
 c6c:	ec26                	sd	s1,24(sp)
 c6e:	b7b5                	j	bda <ithread_create+0x40>
    free(stack_ptr);
 c70:	8526                	mv	a0,s1
 c72:	00000097          	auipc	ra,0x0
 c76:	c9e080e7          	jalr	-866(ra) # 910 <free>
    stacks[num_threads] = 0;
 c7a:	00001717          	auipc	a4,0x1
 c7e:	99672703          	lw	a4,-1642(a4) # 1610 <num_threads>
 c82:	070e                	slli	a4,a4,0x3
 c84:	00001797          	auipc	a5,0x1
 c88:	9847b783          	ld	a5,-1660(a5) # 1608 <stacks>
 c8c:	97ba                	add	a5,a5,a4
 c8e:	0007b023          	sd	zero,0(a5)
 c92:	64e2                	ld	s1,24(sp)
 c94:	bf59                	j	c2a <ithread_create+0x90>

0000000000000c96 <ithread_join>:

int ithread_join(int thread_id) {
 c96:	1101                	addi	sp,sp,-32
 c98:	ec06                	sd	ra,24(sp)
 c9a:	e822                	sd	s0,16(sp)
 c9c:	1000                	addi	s0,sp,32
  int status;
  join_thread(thread_id, (uint64)&status);
 c9e:	fec40593          	addi	a1,s0,-20
 ca2:	00000097          	auipc	ra,0x0
 ca6:	962080e7          	jalr	-1694(ra) # 604 <join_thread>
  threads_done++;
 caa:	00001717          	auipc	a4,0x1
 cae:	96a70713          	addi	a4,a4,-1686 # 1614 <threads_done>
 cb2:	431c                	lw	a5,0(a4)
 cb4:	2785                	addiw	a5,a5,1
 cb6:	c31c                	sw	a5,0(a4)
  if (threads_done == num_threads) {
 cb8:	00001717          	auipc	a4,0x1
 cbc:	95872703          	lw	a4,-1704(a4) # 1610 <num_threads>
 cc0:	00f70863          	beq	a4,a5,cd0 <ithread_join+0x3a>
    free_stacks();
  }
  return status;
}
 cc4:	fec42503          	lw	a0,-20(s0)
 cc8:	60e2                	ld	ra,24(sp)
 cca:	6442                	ld	s0,16(sp)
 ccc:	6105                	addi	sp,sp,32
 cce:	8082                	ret
    free_stacks();
 cd0:	00000097          	auipc	ra,0x0
 cd4:	dd8080e7          	jalr	-552(ra) # aa8 <free_stacks>
 cd8:	b7f5                	j	cc4 <ithread_join+0x2e>
