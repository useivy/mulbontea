rm boot.img
(make -C kernel clear)

(cd bootloader && nasm boot.asm -f bin -o boot.bin)
nasm_done=$?

if [ "$nasm_done" = "0" ]
then
  echo [GOOD] Bootloader compiled successfully
fi

(make -C kernel)
kernel_done=$?

if [ "$kernel_done" = "0" ]
then
  echo [GOOD] Kernel compiled successfully
fi

echo Kernel msg: $kernel_done

if [ "$nasm_done" = "0" ] && [ "$kernel_done" = "0" ]
then
  kernel_size=$(wc -c < kernel/kernel)
  kernel_sectors=$(( ($kernel_size + 511) / 512))
  printf %02x $kernel_sectors | xxd -r -p | dd of=bootloader/boot.bin bs=1 seek=2 conv=notrunc
  
  cp bootloader/boot.bin ./boot.img
  cat kernel/kernel >> boot.img
  dd if=/dev/zero bs=1 count=512 >> boot.img
  echo [GOOD] Build finished. Use boot.img to boot
else
  msgs=`expr $nasm_done + $nasm_done`
  echo Build failed. Messages: $msgs
fi