# --- BUILD STAGE ---
# Verwende ein offizielles Node.js Image als Basis für den Build-Schritt
FROM node:20-alpine AS builder

# Setze das Arbeitsverzeichnis im Container
WORKDIR /app

# Kopiere die Paket-Definitionsdateien
# package.json und package-lock.json (oder yarn.lock/pnpm-lock.yaml)
COPY package.json ./
COPY package-lock.json ./ # Füge diese Zeile nur hinzu, wenn du eine package-lock.json verwendest

# Installiere die Produktionsabhängigkeiten
# 'npm ci' ist besser für CI/CD-Umgebungen, da es die exakte Version aus der lock-Datei verwendet
RUN npm ci --omit=dev

# Kopiere den Rest des Anwendungscodes
COPY . .

# Führe den Next.js Build aus
# Dies erstellt den optimierten Produktions-Build in .next/
RUN npm run build

# --- PRODUCTION STAGE ---
# Verwende ein sehr kleines und sicheres Node.js Image nur für die Laufzeit
FROM node:20-alpine

# Setze das Arbeitsverzeichnis
WORKDIR /app

# Kopiere die generierten Next.js-Assets und die node_modules aus dem Build-Stage
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json # package.json für 'npm start'
COPY --from=builder /app/public ./public # Kopiere den public-Ordner (Bilder, Favicons etc.)

# Setze die Umgebungsvariablen für Next.js (wichtig für Port 3000)
ENV PORT 3000

# Exponiere den Port, auf dem die Anwendung im Container läuft
EXPOSE 3000

# Definiere den Befehl zum Starten der Anwendung, wenn der Container läuft
# 'npm run start' startet die gebuildete Next.js-App
CMD ["npm", "run", "start"]