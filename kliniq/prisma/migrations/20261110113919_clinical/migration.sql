-- CreateEnum
CREATE TYPE "AppointmentStatus" AS ENUM ('BOOKED', 'CHECKED_IN', 'COMPLETED', 'CANCELLED', 'NO_SHOW');

-- CreateEnum
CREATE TYPE "AttachmentKind" AS ENUM ('LAB_RESULT', 'SCAN', 'PRESCRIPTION', 'OTHER');

-- CreateTable
CREATE TABLE "ScheduleRule" (
    "id" SERIAL NOT NULL,
    "clinicianId" INTEGER NOT NULL,
    "weekday" INTEGER NOT NULL,
    "startMinute" INTEGER NOT NULL,
    "endMinute" INTEGER NOT NULL,
    "slotMinutes" INTEGER NOT NULL DEFAULT 20,
    "validFrom" DATE NOT NULL,
    "validTo" DATE,

    CONSTRAINT "ScheduleRule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScheduleException" (
    "id" SERIAL NOT NULL,
    "clinicianId" INTEGER NOT NULL,
    "date" DATE NOT NULL,
    "reason" TEXT NOT NULL,

    CONSTRAINT "ScheduleException_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Appointment" (
    "id" SERIAL NOT NULL,
    "patientId" INTEGER NOT NULL,
    "clinicianId" INTEGER NOT NULL,
    "startsAt" TIMESTAMPTZ(3) NOT NULL,
    "endsAt" TIMESTAMPTZ(3) NOT NULL,
    "status" "AppointmentStatus" NOT NULL DEFAULT 'BOOKED',
    "reason" TEXT,
    "bookedById" INTEGER NOT NULL,
    "cancelledAt" TIMESTAMPTZ(3),
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Appointment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ClinicalNote" (
    "id" SERIAL NOT NULL,
    "appointmentId" INTEGER NOT NULL,
    "patientId" INTEGER NOT NULL,
    "authorId" INTEGER NOT NULL,
    "body" TEXT NOT NULL,
    "isFinal" BOOLEAN NOT NULL DEFAULT false,
    "amendsNoteId" INTEGER,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ClinicalNote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Attachment" (
    "id" SERIAL NOT NULL,
    "patientId" INTEGER NOT NULL,
    "uploadedById" INTEGER NOT NULL,
    "noteId" INTEGER,
    "kind" "AttachmentKind" NOT NULL,
    "storageKey" TEXT NOT NULL,
    "originalName" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "sizeBytes" INTEGER NOT NULL,
    "sha256" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Attachment_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Appointment_clinicianId_startsAt_idx" ON "Appointment"("clinicianId", "startsAt");

-- CreateIndex
CREATE INDEX "Appointment_patientId_startsAt_idx" ON "Appointment"("patientId", "startsAt");

-- CreateIndex
CREATE INDEX "ClinicalNote_patientId_createdAt_idx" ON "ClinicalNote"("patientId", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "Attachment_storageKey_key" ON "Attachment"("storageKey");

-- CreateIndex
CREATE INDEX "Attachment_patientId_idx" ON "Attachment"("patientId");

-- AddForeignKey
ALTER TABLE "ScheduleRule" ADD CONSTRAINT "ScheduleRule_clinicianId_fkey" FOREIGN KEY ("clinicianId") REFERENCES "StaffProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScheduleException" ADD CONSTRAINT "ScheduleException_clinicianId_fkey" FOREIGN KEY ("clinicianId") REFERENCES "StaffProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Appointment" ADD CONSTRAINT "Appointment_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "PatientProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Appointment" ADD CONSTRAINT "Appointment_clinicianId_fkey" FOREIGN KEY ("clinicianId") REFERENCES "StaffProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Appointment" ADD CONSTRAINT "Appointment_bookedById_fkey" FOREIGN KEY ("bookedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClinicalNote" ADD CONSTRAINT "ClinicalNote_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES "Appointment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClinicalNote" ADD CONSTRAINT "ClinicalNote_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "PatientProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClinicalNote" ADD CONSTRAINT "ClinicalNote_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "StaffProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClinicalNote" ADD CONSTRAINT "ClinicalNote_amendsNoteId_fkey" FOREIGN KEY ("amendsNoteId") REFERENCES "ClinicalNote"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Attachment" ADD CONSTRAINT "Attachment_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "PatientProfile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Attachment" ADD CONSTRAINT "Attachment_uploadedById_fkey" FOREIGN KEY ("uploadedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Attachment" ADD CONSTRAINT "Attachment_noteId_fkey" FOREIGN KEY ("noteId") REFERENCES "ClinicalNote"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
